import 'package:riverpod_annotation/riverpod_annotation.dart';

/// Mixin to simplify handling asynchronous state in Riverpod notifiers.
mixin AsyncNotifierMixin<State> on AnyNotifier<AsyncValue<State>, State> {
  Future<void> mutateState(Future<State> Function() body) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(body);
  }
}
