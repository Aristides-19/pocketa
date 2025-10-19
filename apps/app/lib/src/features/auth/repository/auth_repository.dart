import 'package:appwrite/appwrite.dart';
import 'package:pocketa/src/features/auth/auth.dart';
import 'package:pocketa/src/utils/appwrite/exceptions.dart';
import 'package:pocketa/src/utils/appwrite/providers.dart';
import 'package:pocketa/src/utils/services/prefs_service.dart';
import 'package:pocketa/src/utils/services/request_guard_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'auth_repository.g.dart';

class AuthRepository {
  const AuthRepository(this.account, this.request, this.prefs);

  final Account account;
  final RequestGuard request;
  final SharedPreferencesAsync prefs;

  final _lastSessionEmailKey = 'last_session_email';

  Future<void> logInWithEmail(String email, String password) {
    return request.call(
      () async {
        await account.createEmailPasswordSession(
          email: email,
          password: password,
        );
      },
      exceptions: const {
        CredentialsMismatchException(),
        SessionExistsException(),
      },
    );
  }

  Future<Auth> signUp(
    String username,
    String email,
    String password,
    String id,
  ) {
    return request.call(() async {
      await account.create(
        userId: id,
        email: email,
        password: password,
        name: username,
      );
      await account.createEmailPasswordSession(
        email: email,
        password: password,
      );
      await prefs.setString(_lastSessionEmailKey, email);
      return Auth(email: email, $id: id, name: username);
    }, exceptions: const {EmailInUseException()});
  }

  Future<Auth?> getCurrentUser() async {
    return request.call(() async {
      final user = await account.get();
      await prefs.setString(_lastSessionEmailKey, user.email);
      return Auth(email: user.email, $id: user.$id, name: user.name);
    });
  }

  Future<void> logout() {
    return request.call(() async {
      await account.deleteSession(sessionId: 'current');
    });
  }

  String genId() {
    return ID.unique();
  }

  Future<String?> getLastSessionEmail() async {
    return await prefs.getString(_lastSessionEmailKey);
  }
}

@Riverpod(keepAlive: true)
AuthRepository authRepository(Ref ref) {
  final account = ref.read(appwriteAccountProvider);
  final request = ref.read(reqGuardProvider);
  final prefs = ref.read(prefsProvider);
  return AuthRepository(account, request, prefs);
}
