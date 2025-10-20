import 'package:cryptography/cryptography.dart';
import 'package:pocketa/src/features/crypto/repository/key_repository.dart';
import 'package:pocketa/src/features/crypto/utils/crypto_engine.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'crypto_service.g.dart';

// TODO - Add handling for orphan users (users without keys).
//  E.g. request password when trying to create encrypted data to gen a new key.
class CryptoService {
  CryptoService(this._engine, this._repo);

  final CryptoEngine _engine;
  final KeyRepository _repo;

  late SecretKey _privateKey;

  /// Creates a new private key, encrypts it with a key derived from the password in sign up.
  Future<void> createKey(String password, String userId) async {
    final results = await Future.wait([
      _engine.deriveKey(password),
      _engine.genPrivateKey(),
    ]);

    final (derivedKey, salt) = results[0] as (SecretKey, List<int>);
    _privateKey = results[1] as SecretKey;
    await _repo.create(_privateKey, derivedKey, salt, userId);
  }

  /// Init the service by decrypting the private key with a key derived from the password in login.
  /// Password can be null if the key is already stored locally (e.g. session restore).
  /// Else, password is required to decrypt the key.
  Future<void> init({String? password, String? userId}) async {
    _privateKey = (await _repo.getOrElseCreate(password, userId)).$1;
  }

  /// Rotate the private key encryption by re-encrypting it with a new key derived from the new password.
  Future<void> rotateKey(String password) async {
    final (derivedKey, salt) = await _engine.deriveKey(password);
    await _repo.update(_privateKey, derivedKey, salt);
  }

  // Unpersist private key from local storage
  Future<void> logout() async {
    await _repo.logout();
  }
}

@Riverpod(keepAlive: true)
CryptoService crypto(Ref ref) => CryptoService(
  ref.read(cryptoEngineProvider),
  ref.read(keyRepositoryProvider),
);
