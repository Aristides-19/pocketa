import 'dart:convert';

import 'package:cryptography/cryptography.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'engine.g.dart';

typedef KeyPayload = ({SecretKey derivedKey, List<int> salt});

class CryptoEngine {
  final _algorithm = AesGcm.with256bits();
  final _kdf = Argon2id(
    parallelism: 2,
    memory: 65536,
    iterations: 2,
    hashLength: 32,
  );

  /// Derive a key from [password] with optional [salt] (creates new if null).
  /// Returns a record of [KeyPayload] = (derivedKey, salt)
  Future<KeyPayload> deriveKey(String password, {List<int>? salt}) async {
    salt ??= _algorithm.newNonce();
    final key = await _kdf.deriveKeyFromPassword(
      password: password,
      nonce: salt,
    );
    return (derivedKey: key, salt: salt);
  }

  /// Gen a private key. Returns a [SecretKey]
  Future<SecretKey> genPrivateKey() {
    return _algorithm.newSecretKey();
  }

  /// Encrypt [privateKey] with [derivedKey]. Returns a [SecretBox].
  Future<SecretBox> encryptPrivateKey(
    SecretKey privateKey,
    SecretKey derivedKey,
  ) async {
    return _algorithm.encrypt(
      await privateKey.extractBytes(),
      secretKey: derivedKey,
    );
  }

  /// Decrypt [encryptedPrivateKey] with [derivedKey]. Returns a [SecretKey]
  Future<SecretKey> decryptPrivateKey(
    SecretBox encryptedPrivateKey,
    SecretKey derivedKey,
  ) async {
    return SecretKey(
      await _algorithm.decrypt(encryptedPrivateKey, secretKey: derivedKey),
    );
  }

  /// Encrypt [plainText] with [privateKey]. Returns a [SecretBox]
  Future<SecretBox> encrypt(String plainText, SecretKey privateKey) {
    return _algorithm.encrypt(utf8.encode(plainText), secretKey: privateKey);
  }

  /// Decrypt [secretBox] with [privateKey]. Returns a [String] as plain text
  Future<String> decrypt(SecretBox secretBox, SecretKey privateKey) async {
    final decryptedBytes = await _algorithm.decrypt(
      secretBox,
      secretKey: privateKey,
    );
    return utf8.decode(decryptedBytes);
  }
}

@Riverpod(keepAlive: true, name: r'$cryptoEngine')
CryptoEngine cryptoEngine(Ref ref) => CryptoEngine();
