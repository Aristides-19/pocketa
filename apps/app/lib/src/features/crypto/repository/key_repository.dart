import 'dart:convert';

import 'package:cryptography/cryptography.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:pocketa/src/features/crypto/crypto.dart';
import 'package:pocketa/src/features/crypto/models/key.dart';
import 'package:pocketa/src/features/crypto/utils/crypto_engine.dart';
import 'package:pocketa/src/features/crypto/utils/utils.dart';
import 'package:pocketa/src/utils/services/prefs_service.dart';
import 'package:pocketa/src/utils/supabase/supabase.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'key_repository.g.dart';

class KeyRepository {
  KeyRepository(
    this.ref,
    this.securePrefs,
    this._engine,
    this._client,
    this._guard,
  );

  final Ref ref;
  final FlutterSecureStorage securePrefs;
  final CryptoEngine _engine;
  final SupabaseClient _client;
  final SupabaseGuard _guard;

  final _storageKey = 'private_key';
  final _saltKey = 'salt_key';

  Future<void> create(
    SecretKey privateKey,
    SecretKey derivedKey,
    List<int> salt,
    String userId,
  ) {
    return _persist(privateKey, derivedKey, salt, userId: userId);
  }

  Future<void> update(
    SecretKey privateKey,
    SecretKey derivedKey,
    List<int> salt,
  ) {
    return _persist(privateKey, derivedKey, salt);
  }

  Future<void> _persist(
    SecretKey privateKey,
    SecretKey derivedKey,
    List<int> salt, {
    String? userId,
  }) {
    return _guard.callPG(() async {
      final key = Key(
        encryptedKeyb64: secretBoxToBase64(
          await _engine.encryptPrivateKey(privateKey, derivedKey),
        ),
        saltb64: base64Encode(salt),
        privateKeyb64: await secretKeyToBase64(privateKey),
      ).toJson();

      await _client.rpc(
        'upsert_user_key',
        params: {
          'p_encrypted_key': key['encrypted_key'],
          'p_salt': key['salt'],
        },
      );

      await Future.wait([
        securePrefs.write(
          key: _storageKey,
          value: key['private_key'] as String,
        ),
        securePrefs.write(key: _saltKey, value: key['salt'] as String),
      ]);
    });
  }

  Future<(SecretKey, List<int>)> getOrElseCreate(
    String? password,
    String? userId,
  ) {
    return _guard.callPG(() async {
      final [privateKeyb64, saltb64] = await Future.wait([
        securePrefs.read(key: _storageKey),
        securePrefs.read(key: _saltKey),
      ]);
      if (privateKeyb64 != null && saltb64 != null) {
        return (secretKeyFromBase64(privateKeyb64), base64Decode(saltb64));
      }

      if (password == null) throw const PasswordRequiredException();
      assert(userId != null, 'userId is required to fetch the key.');

      Map<String, dynamic>? document;
      try {
        document = await _client.rpc<Map<String, dynamic>>(
          'get_user_key',
          get: true,
          params: {},
        );
      } on PostgrestException catch (e) {
        if (e.code != 'P0002') rethrow; // no data found
      }

      if (document == null) {
        final results = await Future.wait([
          _engine.deriveKey(password),
          _engine.genPrivateKey(),
        ]);

        final (derivedKey, salt) = results[0] as (SecretKey, List<int>);
        final privateKey = results[1] as SecretKey;
        await create(privateKey, derivedKey, salt, userId!);
        return (privateKey, salt);
      }

      var key = Key.fromJson(document);
      final encryptedKey = secretBoxFromBase64(key.encryptedKeyb64!);
      final salt = base64Decode(key.saltb64);

      final (derivedKey, _) = await _engine.deriveKey(password, salt: salt);
      final privateKey = await _engine.decryptPrivateKey(
        encryptedKey,
        derivedKey,
      );
      final privateKeyBase64 = await secretKeyToBase64(privateKey);

      await securePrefs.write(key: _storageKey, value: privateKeyBase64);
      await securePrefs.write(key: _saltKey, value: key.saltb64);

      return (privateKey, salt);
    }, exceptions: {const RPCNoDataFoundException()});
  }

  Future<void> logout() {
    return _guard.call(() async {
      await Future.wait([
        securePrefs.delete(key: _storageKey),
        securePrefs.delete(key: _saltKey),
      ]);
    });
  }
}

@Riverpod(keepAlive: true)
KeyRepository keyRepository(Ref ref) => KeyRepository(
  ref,
  ref.read(securePrefsProvider),
  ref.read(cryptoEngineProvider),
  ref.read(supabaseClient),
  ref.read(supGuardProvider),
);
