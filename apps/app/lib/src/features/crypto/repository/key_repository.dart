import 'dart:convert';

import 'package:cryptography/cryptography.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:pocketa/src/features/crypto/crypto.dart';
import 'package:pocketa/src/features/crypto/models/key.dart';
import 'package:pocketa/src/features/crypto/utils/encode.dart';
import 'package:pocketa/src/features/crypto/utils/engine.dart';
import 'package:pocketa/src/utils/services/prefs_provider.dart';
import 'package:pocketa/src/utils/supabase/supabase.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'key_repository.g.dart';

typedef KeyPayload = ({SecretKey privateKey, List<int> salt});

class KeyRepository {
  KeyRepository(this._prefs, this._engine, this._client, this._handler);

  final FlutterSecureStorage _prefs;
  final CryptoEngine _engine;
  final SupabaseClient _client;
  final SupabaseHandler _handler;

  final _storageKey = 'private_key';

  Future<SecretKey> upsert({required String password, SecretKey? privateKey}) {
    return _handler.callPG(() async {
      privateKey ??= await _engine.genPrivateKey();
      final (:derivedKey, :salt) = await _engine.deriveKey(password);

      // Encrypt private key with derived key from password
      final key = Key(
        encryptedKeyb64: secretBoxToBase64(
          await _engine.encryptPrivateKey(privateKey!, derivedKey),
        ),
        saltb64: base64Encode(salt),
        privateKeyb64: await secretKeyToBase64(privateKey!),
      );

      // Store encrypted key in Supabase
      await _client.rpc(
        'upsert_user_key',
        params: {'p_encrypted_key': key.encryptedKeyb64, 'p_salt': key.saltb64},
      );

      // Store unencrypted key locally
      await _prefs.write(key: _storageKey, value: key.privateKeyb64);

      return privateKey!;
    });
  }

  Future<SecretKey> getOrElseCreate({String? password}) {
    return _handler.callPG(() async {
      // Session restore, try to get local key
      if (password == null) {
        final privateKeyb64 = await _prefs.read(key: _storageKey);
        if (privateKeyb64 != null) return secretKeyFromBase64(privateKeyb64);
        throw const PasswordRequiredException();
      }

      // Try to get it from Supabase
      Map<String, dynamic> document;
      try {
        document = await _client.rpc<Map<String, dynamic>>(
          'get_user_key',
          get: true,
          params: {},
        );
      } on PostgrestException catch (e) {
        // Not found, create new key
        if (const RPCNoDataFoundException().matches(e)) {
          return upsert(password: password);
        }
        rethrow;
      }

      // Found, decrypt and return
      final key = Key.fromJson(document);
      final encryptedKey = secretBoxFromBase64(key.encryptedKeyb64!);
      final salt = base64Decode(key.saltb64);

      // Re derive key from password (same salt)
      final (:derivedKey, salt: _) = await _engine.deriveKey(
        password,
        salt: salt,
      );
      // Decrypt private key
      final privateKey = await _engine.decryptPrivateKey(
        encryptedKey,
        derivedKey,
      );
      final privateKeyBase64 = await secretKeyToBase64(privateKey);

      // Update stored unencrypted key locally
      await _prefs.write(key: _storageKey, value: privateKeyBase64);

      return privateKey;
    }, exceptions: {const RPCNoDataFoundException()});
  }

  Future<void> clearLocalKey() {
    return _handler.call(() async {
      await _prefs.delete(key: _storageKey);
    });
  }
}

@Riverpod(keepAlive: true, name: 'keyRepository')
KeyRepository keyRepo(Ref ref) => KeyRepository(
  ref.read(securePreferences),
  ref.read(cryptoEngine),
  ref.read(supabaseClient),
  ref.read(supabaseHandler),
);
