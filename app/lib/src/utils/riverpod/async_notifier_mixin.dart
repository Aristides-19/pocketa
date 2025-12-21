import 'package:riverpod_annotation/riverpod_annotation.dart';

mixin AsyncNotifierMixin<State> on AnyNotifier<AsyncValue<State>, State> {
  Future<void> mutateState(Future<State> Function() body) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(body);
  }
}
