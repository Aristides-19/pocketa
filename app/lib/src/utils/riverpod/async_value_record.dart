import 'package:hooks_riverpod/hooks_riverpod.dart';

/// Combines two [AsyncValue]s into one [AsyncValue] containing a tuple of their values.
/// Useful for watching and depending on multiple asynchronous states simultaneously.
/// - If any of the [AsyncValue]s is in an error state, the combined [AsyncValue] will also be in an error state.
/// - If any of the [AsyncValue]s is loading, the combined [AsyncValue] will be in a loading state.
/// ### Note
/// This extension won't be useful for complex states such as `isLoading`.
/// For instance, if riverpod is returning [AsyncData] but with `isLoading` true,
/// this extension will still return [AsyncData] but with `isLoading` false,
/// because it only checks for [AsyncLoading] state.
/// - In this case, you should check for [AsyncValue<T1>.isLoading] or [AsyncValue<T2>.isLoading] separately.
extension AsyncValueRecord2<T1, T2> on (AsyncValue<T1>, AsyncValue<T2>) {
  AsyncValue<(T1, T2)> watch() {
    if ($1 is AsyncLoading || $2 is AsyncLoading) return const AsyncLoading();

    if ($1 is AsyncError) return AsyncError($1.error!, $1.stackTrace!);
    if ($2 is AsyncError) return AsyncError($2.error!, $2.stackTrace!);

    return AsyncData(($1.requireValue, $2.requireValue));
  }
}

/// Combines three [AsyncValue]s into one [AsyncValue] containing a tuple of their values.
/// Useful for watching and depending on multiple asynchronous states simultaneously.
/// - If any of the [AsyncValue]s is in an error state, the combined [AsyncValue] will also be in an error state.
/// - If any of the [AsyncValue]s is loading, the combined [AsyncValue] will be in a loading state.
/// ### Note
/// This extension won't be useful for complex states such as `isLoading`.
/// For instance, if riverpod is returning [AsyncData] but with `isLoading` true,
/// this extension will still return [AsyncData] but with `isLoading` false,
/// because it only checks for [AsyncLoading] state.
/// - In this case, you should check for [AsyncValue<T1>.isLoading] or [AsyncValue<T2>.isLoading] or [AsyncValue<T3>.isLoading] separately.
extension AsyncValueRecord3<T1, T2, T3>
    on (AsyncValue<T1>, AsyncValue<T2>, AsyncValue<T3>) {
  AsyncValue<(T1, T2, T3)> watch() {
    if ($1 is AsyncLoading || $2 is AsyncLoading || $3 is AsyncLoading) {
      return const AsyncLoading();
    }

    if ($1 is AsyncError) return AsyncError($1.error!, $1.stackTrace!);
    if ($2 is AsyncError) return AsyncError($2.error!, $2.stackTrace!);
    if ($3 is AsyncError) return AsyncError($3.error!, $3.stackTrace!);

    return AsyncData(($1.requireValue, $2.requireValue, $3.requireValue));
  }
}
