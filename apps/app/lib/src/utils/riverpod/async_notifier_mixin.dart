import 'package:pocketa/src/features/auth/auth.dart';
import 'package:pocketa/src/utils/appwrite/exceptions.dart';
import 'package:pocketa/src/utils/services/logger_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

mixin AsyncNotifierMixin<State> on AnyNotifier<AsyncValue<State>, State> {
  @override
  void runBuild() {
    try {
      super.runBuild();
    } on SessionRequiredException {
      ref.invalidate(authProvider);
      rethrow;
    }
  }

  Future<R> _authGuard<R>(Future<R> Function() body) async {
    try {
      return await body();
    } on SessionRequiredException {
      ref.invalidate(authProvider);
      ref.read(loggerProvider).i('Session required, invalidating authProvider');
      rethrow;
    }
  }

  Future<void> mutateState(Future<State> Function() body) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _authGuard(body));
  }
}
