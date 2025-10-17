import 'package:pocketa/src/features/auth/auth.dart';

class AuthState {
  final Auth? user;
  final AuthChangeReason? reason;

  AuthState({required this.user, required this.reason});
}

enum AuthChangeReason { sessionRestore, login, signup, logout }
