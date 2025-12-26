import 'package:hooks_riverpod/hooks_riverpod.dart';

/// Combines two [AsyncValue]s into one [AsyncValue] containing a tuple of their values.
/// Useful for watching and depending on multiple asynchronous states simultaneously.
/// - If any of the [AsyncValue]s is in an error state, the combined [AsyncValue] will also be in an error state.
/// - If any of the [AsyncValue]s is loading, the combined [AsyncValue] will be in a loading state.
extension AsyncValueRecord2<T1, T2> on (AsyncValue<T1>, AsyncValue<T2>) {
  AsyncValue<(T1, T2)> watch() {
    if ($1.hasError) {
      return AsyncError($1.error!, $1.stackTrace!);
    }
    if ($2.hasError) {
      return AsyncError($2.error!, $2.stackTrace!);
    }

    if ($1.isLoading || $2.isLoading) {
      return const AsyncLoading();
    }

    return AsyncData(($1.requireValue, $2.requireValue));
  }
}

/// Combines three [AsyncValue]s into one [AsyncValue] containing a tuple of their values.
/// Useful for watching and depending on multiple asynchronous states simultaneously.
/// - If any of the [AsyncValue]s is in an error state, the combined [AsyncValue] will also be in an error state.
/// - If any of the [AsyncValue]s is loading, the combined [AsyncValue] will be in a loading state.
extension AsyncValueRecord3<T1, T2, T3>
    on (AsyncValue<T1>, AsyncValue<T2>, AsyncValue<T3>) {
  AsyncValue<(T1, T2, T3)> watch() {
    if ($1.hasError) {
      return AsyncError($1.error!, $1.stackTrace!);
    }
    if ($2.hasError) {
      return AsyncError($2.error!, $2.stackTrace!);
    }
    if ($3.hasError) {
      return AsyncError($3.error!, $3.stackTrace!);
    }

    if ($1.isLoading || $2.isLoading || $3.isLoading) {
      return const AsyncLoading();
    }

    return AsyncData(($1.requireValue, $2.requireValue, $3.requireValue));
  }
}
