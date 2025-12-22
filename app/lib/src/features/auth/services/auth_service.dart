import 'package:pocketa/src/features/auth/models/auth_state.dart';
import 'package:pocketa/src/features/auth/repository/auth_repository.dart';
import 'package:pocketa/src/features/crypto/crypto.dart';
import 'package:pocketa/src/utils/riverpod/riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_service.g.dart';

// TODO - Add retry logic for network errors
@Riverpod(keepAlive: true, name: r'$authStreamQuery')
class AuthStream extends _$AuthStream {
  @override
  Stream<AuthState> build() {
    return ref.read($authRepository).authStateStream;
  }
}

@Riverpod(keepAlive: true, name: r'$authMutation')
class AuthMutation extends _$AuthMutation with AsyncNotifierMixin {
  late AuthRepository _repo;

  @override
  Future<void> build() async {
    _repo = ref.read($authRepository);
  }

  Future<void> logIn(String email, String password) async {
    if (state.isLoading) return;
    await mutateState(() async {
      await _repo.logInWithEmail(email, password);
      await ref.read($cryptoService.notifier).init(password: password);
    });
  }

  Future<void> signUp(String username, String email, String password) async {
    if (state.isLoading) return;
    await mutateState(() async {
      await _repo.signUp(username, email, password);
      await ref.read($cryptoService.notifier).createKey(password);
    });
  }

  /// Use [force] to logout when it is critical to surpass the loading state
  Future<void> logout({bool force = false}) async {
    if (state.isLoading && !force) return;
    await mutateState(() async {
      await _repo.logout();
    });
  }

  Future<String?> getLastSessionEmail() async {
    return _repo.getLastSessionEmail();
  }
}
