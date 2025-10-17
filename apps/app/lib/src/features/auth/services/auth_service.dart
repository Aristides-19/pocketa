import 'package:pocketa/src/features/auth/models/auth_state.dart';
import 'package:pocketa/src/features/auth/repository/auth_repository.dart';
import 'package:pocketa/src/utils/services/logger_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_service.g.dart';

// TODO - Add retry logic for network errors
@Riverpod(keepAlive: true, name: 'authProvider')
class AuthService extends _$AuthService {
  late AuthRepository _repo;

  @override
  Future<AuthState> build() async {
    ref.read(loggerProvider).i('AuthService initialized');
    _repo = ref.read(authRepositoryProvider);

    final user = await _repo.getCurrentUser();
    return AuthState(
      user: user,
      reason: user != null ? AuthChangeReason.sessionRestore : null,
    );
  }

  Future<void> logIn(String email, String password) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await _repo.logInWithEmail(email, password);

      final auth = await _repo.getCurrentUser();
      return AuthState(user: auth, reason: AuthChangeReason.login);
    });
  }

  Future<void> signUp(String username, String email, String password) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final id = _repo.genId();
      final auth = await _repo.signUp(username, email, password, id);
      return AuthState(user: auth, reason: AuthChangeReason.signup);
    });
  }
}
