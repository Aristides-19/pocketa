import 'dart:convert';

import 'package:cryptography/cryptography.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:pocketa/src/features/auth/auth.dart';
import 'package:pocketa/src/features/crypto/crypto.dart';
import 'package:pocketa/src/features/crypto/models/key.dart';
import 'package:pocketa/src/features/crypto/utils/encode.dart';
import 'package:pocketa/src/features/crypto/utils/engine.dart';
import 'package:pocketa/src/utils/services/prefs_service.dart';
import 'package:pocketa/src/utils/supabase/supabase.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'key_repository.g.dart';

typedef KeyPayload = ({SecretKey privateKey, List<int> salt});

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

  Future<SecretKey> upsert({required String password, SecretKey? privateKey}) {
    return _guard.callPG(() async {
      // FIXME - only call a service from services, this leads to unknown exceptions
      final user = ref.read(authStreamProvider).requireValue.user;
      assert(user != null, 'User must be logged in to upsert the key.');

      privateKey ??= await _engine.genPrivateKey();
      final (:derivedKey, :salt) = await _engine.deriveKey(password);

      final key = Key(
        encryptedKeyb64: secretBoxToBase64(
          await _engine.encryptPrivateKey(privateKey!, derivedKey),
        ),
        saltb64: base64Encode(salt),
        privateKeyb64: await secretKeyToBase64(privateKey!),
      ).toJson();

      await _client.rpc(
        'upsert_user_key',
        params: {
          'p_encrypted_key': key['encrypted_key'],
          'p_salt': key['salt'],
        },
      );

      await securePrefs.write(
        key: _storageKey,
        value: key['private_key'] as String,
      );

      return privateKey!;
    });
  }

  Future<SecretKey> getOrElseCreate({String? password}) {
    return _guard.callPG(() async {
      final user = ref.read(authStreamProvider).requireValue.user;
      assert(user != null, 'User must be logged in to fetch the key.');

      final privateKeyb64 = await securePrefs.read(key: _storageKey);
      if (privateKeyb64 != null) {
        return secretKeyFromBase64(privateKeyb64);
      }

      if (password == null) throw const PasswordRequiredException();

      Map<String, dynamic>? document;
      try {
        document = await _client.rpc<Map<String, dynamic>>(
          'get_user_key',
          get: true,
          params: {},
        );
      } on PostgrestException catch (e) {
        if (!(const RPCNoDataFoundException().matches(e))) {
          rethrow;
        } // no data found
      }

      if (document == null) return upsert(password: password);

      final key = Key.fromJson(document);
      final encryptedKey = secretBoxFromBase64(key.encryptedKeyb64!);
      final salt = base64Decode(key.saltb64);

      final (:derivedKey, salt: _) = await _engine.deriveKey(
        password,
        salt: salt,
      );
      final privateKey = await _engine.decryptPrivateKey(
        encryptedKey,
        derivedKey,
      );
      final privateKeyBase64 = await secretKeyToBase64(privateKey);

      await securePrefs.write(key: _storageKey, value: privateKeyBase64);

      return privateKey;
    }, exceptions: {const RPCNoDataFoundException()});
  }

  Future<void> clearLocalKey() {
    return _guard.call(() async {
      await securePrefs.delete(key: _storageKey);
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
