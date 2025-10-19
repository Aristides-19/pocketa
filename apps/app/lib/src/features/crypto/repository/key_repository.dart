import 'dart:convert';

import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:cryptography/cryptography.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:pocketa/src/constants/constants.dart';
import 'package:pocketa/src/features/auth/auth.dart';
import 'package:pocketa/src/features/crypto/crypto.dart';
import 'package:pocketa/src/features/crypto/models/key.dart';
import 'package:pocketa/src/features/crypto/utils/crypto_engine.dart';
import 'package:pocketa/src/features/crypto/utils/utils.dart';
import 'package:pocketa/src/utils/appwrite/providers.dart';
import 'package:pocketa/src/utils/appwrite/utils.dart';
import 'package:pocketa/src/utils/services/prefs_service.dart';
import 'package:pocketa/src/utils/services/request_guard_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'key_repository.g.dart';

class KeyRepository {
  KeyRepository(
    this.ref,
    this.db,
    this.securePrefs,
    this.request,
    this._engine,
  );

  final Ref ref;
  final TablesDB db;
  final FlutterSecureStorage securePrefs;
  final RequestGuard request;
  final CryptoEngine _engine;

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
    return request.call(() async {
      final id = userId ?? ref.read(authProvider).value!.user!.$id;

      final key = Key(
        encryptedKeyb64: secretBoxToBase64(
          await _engine.encryptPrivateKey(privateKey, derivedKey),
        ),
        saltb64: base64Encode(salt),
        privateKeyb64: await secretKeyToBase64(privateKey),
      ).toJson();

      await db.upsertRow(
        databaseId: AppEnv.databaseId,
        tableId: AppEnv.keysCollectionId,
        rowId: id,
        data: Map.fromEntries(key.entries.where((e) => e.key != 'privateKey')),
        permissions: userPermissions(id),
      );

      await Future.wait([
        securePrefs.write(key: _storageKey, value: key['privateKey'] as String),
        securePrefs.write(key: _saltKey, value: key['salt'] as String),
      ]);
    });
  }

  Future<(SecretKey, List<int>)> get(String? password, String? userId) {
    return request.call(() async {
      final [privateKeyb64, saltb64] = await Future.wait([
        securePrefs.read(key: _storageKey),
        securePrefs.read(key: _saltKey),
      ]);
      if (privateKeyb64 != null && saltb64 != null) {
        return (secretKeyFromBase64(privateKeyb64), base64Decode(saltb64));
      }

      if (password == null) throw const PasswordRequiredException();
      if (userId == null) {
        throw Exception('userId is required to fetch the key.');
      }

      Row? document;
      try {
        document = await db.getRow(
          databaseId: AppEnv.databaseId,
          tableId: AppEnv.keysCollectionId,
          rowId: userId,
        );
      } on AppwriteException catch (e) {
        if (e.type != 'row_not_found') rethrow;
      }

      if (document == null) {
        final results = await Future.wait([
          _engine.deriveKey(password),
          _engine.genPrivateKey(),
        ]);

        final (derivedKey, salt) = results[0] as (SecretKey, List<int>);
        final privateKey = results[1] as SecretKey;
        await create(privateKey, derivedKey, salt, userId);
        return (privateKey, salt);
      }

      var key = Key.fromJson(document.data);
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
    });
  }

  Future<void> logout() {
    return request.call(() async {
      await Future.wait([
        securePrefs.delete(key: _storageKey),
        securePrefs.delete(key: _saltKey),
      ]);
    });
  }
}

@Riverpod(keepAlive: true)
KeyRepository keyRepository(Ref ref) {
  final db = ref.read(appwriteDbProvider);
  final securePrefs = ref.read(securePrefsProvider);
  final request = ref.read(reqGuardProvider);
  final engine = ref.read(cryptoEngineProvider);
  return KeyRepository(ref, db, securePrefs, request, engine);
}
