import 'package:cryptography/cryptography.dart';
import 'package:pocketa/src/features/crypto/repository/key_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'crypto_service.g.dart';

class CryptoService {
  CryptoService(this._repo);
  final KeyRepository _repo;

  late SecretKey _privateKey;

  /// Creates a new private key, encrypts it with a key derived from the password in sign up.
  Future<void> createKey(String password) async {
    await _repo.upsert(password: password);
  }

  /// Init the service by decrypting the private key with a key derived from the password in login.
  /// Password can be null if the key is already stored locally (e.g. session restore).
  /// Else, password is required to decrypt the key.
  Future<void> init({String? password}) async {
    _privateKey = await _repo.getOrElseCreate(password: password);
  }

  /// Rotate the private key encryption by re-encrypting it with a new key derived from the new password.
  Future<void> rotateKey(String password) async {
    await _repo.upsert(password: password, privateKey: _privateKey);
  }

  // Clear private key from local storage
  Future<void> clearLocalKey() async {
    await _repo.clearLocalKey();
  }
}

@Riverpod(keepAlive: true)
CryptoService crypto(Ref ref) => CryptoService(ref.read(keyRepositoryProvider));
