import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pocketa/src/features/auth/auth.dart';

part 'auth_state.freezed.dart';

@freezed
abstract class AuthState with _$AuthState {
  const factory AuthState({
    required Auth? user,
    required AuthChangeReason? reason,
  }) = _AuthState;
}

enum AuthChangeReason { sessionRestore, login, signup, logout, refresh }
