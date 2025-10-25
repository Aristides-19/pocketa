import 'package:pocketa/src/features/auth/models/auth_state.dart';
import 'package:pocketa/src/features/auth/repository/auth_repository.dart';
import 'package:pocketa/src/features/crypto/crypto.dart';
import 'package:pocketa/src/utils/riverpod/async_notifier_mixin.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_service.g.dart';

// TODO - Add retry logic for network errors
@Riverpod(keepAlive: true)
class AuthStream extends _$AuthStream {
  @override
  Stream<AuthState> build() {
    return ref.read(authRepositoryProvider).authStateStream;
  }
}

@riverpod
class AuthMutation extends _$AuthMutation with AsyncNotifierMixin {
  late AuthRepository _repo;

  @override
  Future<void> build() async {
    _repo = ref.read(authRepositoryProvider);
  }

  Future<void> logIn(String email, String password) async {
    if (state.isLoading) return;
    await mutateState(() async {
      await _repo.logInWithEmail(email, password);
      try {
        await ref.read(cryptoProvider).init(password: password);
      } on Exception catch (_) {
        await _repo.logout();
        throw const PasswordRequiredException();
      }
    });
  }

  Future<void> signUp(String username, String email, String password) async {
    if (state.isLoading) return;
    await mutateState(() async {
      await _repo.signUp(username, email, password);
      try {
        await ref.read(cryptoProvider).createKey(password);
      } on Exception catch (_) {
        await _repo.logout();
        throw const PasswordRequiredException();
      }
    });
  }

  Future<void> logout() async {
    if (state.isLoading) return;
    await mutateState(() async {
      await _repo.logout();
    });
  }

  Future<String?> getLastSessionEmail() async {
    return _repo.getLastSessionEmail();
  }
}
