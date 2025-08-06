import 'package:pocketa/src/features/auth/auth.dart';
import 'package:pocketa/src/features/auth/repository/auth_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'controller.g.dart';

@riverpod
class AuthController extends _$AuthController {
  @override
  Future<void> build() => Future.value();

  Future<void> logIn(String email, String password) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await ref.read(authRepositoryProvider).logInWithEmail(email, password);
      ref.invalidate(authServiceProvider);
    });
  }
}
