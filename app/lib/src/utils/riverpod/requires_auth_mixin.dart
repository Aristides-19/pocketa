import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pocketa/src/features/auth/auth.dart';

/// Providers dependent on `AuthStream` can extend this class to
/// handle authenticated state changes. If there is no
/// authenticated user, the state will be `null`.
mixin RequiresAuthMixin<State> on AnyNotifier<AsyncValue<State?>, State?> {
  Future<State?> whenAuthenticated(
    Future<State> Function(String userId) action,
  ) async {
    final id = ref.watch(
      $authStreamQuery.select((curr) => curr.value?.user?.$id),
    );
    if (id == null) return null;
    return action(id);
  }
}
