import 'package:pocketa/src/features/auth/auth.dart';
import 'package:pocketa/src/utils/services/prefs_service.dart';
import 'package:pocketa/src/utils/supabase/supabase.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supabase;

part 'auth_repository.g.dart';

class AuthRepository {
  const AuthRepository(this._guard, this._prefs, this._client);

  final SupabaseGuard _guard;
  final SharedPreferencesAsync _prefs;
  final supabase.SupabaseClient _client;

  final _lastSessionEmailKey = 'last_session_email';
  final _nameKey = 'display_name';

  Stream<AuthState> get authStateStream {
    return _client.auth.onAuthStateChange.map((data) {
      final user = data.session?.user;
      final event = data.event;

      if (user == null) {
        if (event == supabase.AuthChangeEvent.initialSession) {
          return const AuthState(user: null, reason: null);
        }
        if (event == supabase.AuthChangeEvent.tokenRefreshed) {
          return const AuthState(user: null, reason: AuthChangeReason.expired);
        }
        return const AuthState(user: null, reason: AuthChangeReason.logout);
      }

      final auth = Auth(
        $id: user.id,
        email: user.email!,
        name: user.userMetadata?[_nameKey] as String? ?? '',
      );

      AuthChangeReason? reason;
      switch (event) {
        case supabase.AuthChangeEvent.initialSession:
          reason = AuthChangeReason.restore;
          break;
        case supabase.AuthChangeEvent.signedIn:
          final lastSignIn = user.lastSignInAt == null
              ? DateTime.now()
              : DateTime.parse(user.lastSignInAt!);
          final created = DateTime.parse(user.createdAt);

          if (lastSignIn.difference(created).inSeconds < 2) {
            reason = AuthChangeReason.signup;
          } else {
            reason = AuthChangeReason.login;
          }
          break;
        case supabase.AuthChangeEvent.userUpdated:
        case supabase.AuthChangeEvent.tokenRefreshed:
          reason = AuthChangeReason.refresh;
          break;
        case supabase.AuthChangeEvent.signedOut:
          reason = AuthChangeReason.logout;
          break;
        default:
          reason = null;
      }

      return AuthState(user: auth, reason: reason);
    });
  }

  Future<Auth> signUp(String name, String email, String password) {
    return _guard.callAuth(
      () async {
        final response = await _client.auth.signUp(
          email: email,
          password: password,
          data: {_nameKey: name},
        );
        await _prefs.setString(_lastSessionEmailKey, email);
        return Auth(email: email, $id: response.user!.id, name: name);
      },
      exceptions: {
        const EmailInUseException(),
        const SignUpDisabledException(),
        const WeakPasswordException(),
      },
    );
  }

  Future<Auth> logInWithEmail(String email, String password) {
    return _guard.callAuth(
      () async {
        final response = await _client.auth.signInWithPassword(
          email: email,
          password: password,
        );
        await _prefs.setString(_lastSessionEmailKey, email);
        return Auth(
          email: email,
          $id: response.user!.id,
          name: response.user!.userMetadata?[_nameKey] as String? ?? '',
        );
      },
      exceptions: {
        const EmailNotConfirmedException(),
        const CredentialsMismatchException(),
      },
    );
  }

  Future<void> logout() {
    return _guard.callAuth(() async {
      await _client.auth.signOut();
    }, exceptions: {const SessionMissingException()});
  }

  Future<String?> getLastSessionEmail() async {
    return _prefs.getString(_lastSessionEmailKey);
  }
}

@Riverpod(keepAlive: true)
AuthRepository authRepository(Ref ref) => AuthRepository(
  ref.read(supGuardProvider),
  ref.read(prefsProvider),
  ref.read(supabaseClient),
);
