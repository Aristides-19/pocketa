import 'package:cryptography/cryptography.dart';
import 'package:pocketa/src/features/auth/auth.dart';
import 'package:pocketa/src/features/crypto/repository/key_repository.dart';
import 'package:pocketa/src/utils/riverpod/async_notifier_mixin.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'crypto_service.g.dart';

@Riverpod(keepAlive: true, name: 'cryptoService')
class Crypto extends _$Crypto with AsyncNotifierMixin {
  late KeyRepository _repo;
  late SecretKey _privateKey;

  @override
  Future<void> build() async {
    _repo = ref.read(keyRepository);

    ref.listen(authStream, (_, curr) async {
      if (curr.isLoading) return;
      final val = curr.unwrapPrevious().value;

      if (val != null) {
        if (val.user == null) {
          await _clearLocalKey();
          return;
        }

        switch (val.reason) {
          case AuthChangeReason.restore:
            await init();
            break;
          case AuthChangeReason.logout:
          case AuthChangeReason.expired:
            await _clearLocalKey();
            break;
          default:
            break;
        }
      }
    });
  }

  /// Creates a new private key, encrypts it with a key derived from the password in sign up.
  Future<void> createKey(String password) async {
    await mutateState(() async {
      try {
        _privateKey = await _repo.upsert(password: password);
      } on Exception {
        await ref.read(authMutation.notifier).logout();
        rethrow;
      }
    });
  }

  /// Init the service by decrypting the private key with a key derived from the password in login.
  /// Password can be null if the key is already stored locally (e.g. session restore).
  /// Else, password is required to decrypt the key.
  Future<void> init({String? password}) async {
    await mutateState(() async {
      try {
        _privateKey = await _repo.getOrElseCreate(password: password);
      } on Exception {
        await ref.read(authMutation.notifier).logout();
        rethrow;
      }
    });
  }

  /// Rotate the private key encryption by re-encrypting it with a new key derived from the new password.
  Future<void> rotateKey(String password) async {
    await mutateState(() async {
      await _repo.upsert(password: password, privateKey: _privateKey);
    });
  }

  /// Clear private key from local storage
  Future<void> _clearLocalKey() async {
    await mutateState(() async {
      await _repo.clearLocalKey();
    });
  }
}
