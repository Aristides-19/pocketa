import 'package:pocketa/src/features/auth/models/auth_state.dart';
import 'package:pocketa/src/features/auth/repository/auth_repository.dart';
import 'package:pocketa/src/features/crypto/crypto.dart';
import 'package:pocketa/src/utils/appwrite/exceptions.dart';
import 'package:pocketa/src/utils/riverpod/async_notifier_mixin.dart';
import 'package:pocketa/src/utils/services/logger_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_service.g.dart';

// TODO - Add retry logic for network errors
@Riverpod(keepAlive: true, name: 'authProvider')
class AuthService extends _$AuthService with AsyncNotifierMixin {
  late AuthRepository _repo;

  @override
  Future<AuthState> build() async {
    ref.read(loggerProvider).i('AuthService initialized');
    _repo = ref.read(authRepositoryProvider);

    try {
      final user = await _repo.getCurrentUser();
      return AuthState(user: user, reason: AuthChangeReason.sessionRestore);
    } on SessionRequiredException {
      return const AuthState(user: null, reason: null);
    }
  }

  Future<void> logIn(String email, String password) async {
    await mutateState(() async {
      await _repo.logInWithEmail(email, password);

      final auth = await _repo.getCurrentUser();
      await ref
          .read(cryptoProvider)
          .init(password: password, userId: auth!.$id);
      return AuthState(user: auth, reason: AuthChangeReason.login);
    });
  }

  Future<void> signUp(String username, String email, String password) async {
    await mutateState(() async {
      final id = _repo.genId();

      final auth = await _repo.signUp(username, email, password, id);
      await ref.read(cryptoProvider).createKey(password, id);
      return AuthState(user: auth, reason: AuthChangeReason.signup);
    });
  }

  Future<void> logout() async {
    await mutateState(() async {
      await _repo.logout();
      return const AuthState(user: null, reason: AuthChangeReason.logout);
    });
  }

  Future<String?> getLastSessionEmail() async {
    return _repo.getLastSessionEmail();
  }
}
