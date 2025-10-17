import 'dart:convert';

import 'package:cryptography/cryptography.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'crypto_engine.g.dart';

class CryptoEngine {
  final _algorithm = AesGcm.with256bits();
  final _kdf = Argon2id(
    parallelism: 2,
    memory: 65536,
    iterations: 2,
    hashLength: 32,
  );

  Future<(SecretKey, List<int>)> deriveKey(
    String password, {
    List<int>? salt,
  }) async {
    salt ??= _algorithm.newNonce();
    final key = await _kdf.deriveKeyFromPassword(
      password: password,
      nonce: salt,
    );
    return (key, salt);
  }

  Future<SecretKey> genPrivateKey() {
    return _algorithm.newSecretKey();
  }

  Future<SecretBox> encryptPrivateKey(
    SecretKey privateKey,
    SecretKey derivedKey,
  ) async {
    return _algorithm.encrypt(
      await privateKey.extractBytes(),
      secretKey: derivedKey,
    );
  }

  Future<SecretKey> decryptPrivateKey(
    SecretBox encryptedPrivateKey,
    SecretKey derivedKey,
  ) async {
    return SecretKey(
      await _algorithm.decrypt(encryptedPrivateKey, secretKey: derivedKey),
    );
  }

  Future<SecretBox> encrypt(String plainText, SecretKey privateKey) {
    return _algorithm.encrypt(utf8.encode(plainText), secretKey: privateKey);
  }

  Future<String> decrypt(SecretBox secretBox, SecretKey privateKey) async {
    final decryptedBytes = await _algorithm.decrypt(
      secretBox,
      secretKey: privateKey,
    );
    return utf8.decode(decryptedBytes);
  }
}

@Riverpod(keepAlive: true)
CryptoEngine cryptoEngine(Ref ref) {
  return CryptoEngine();
}
