import 'package:appwrite/appwrite.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pocketa/src/features/auth/auth.dart';
import 'package:pocketa/src/utils/appwrite/exceptions.dart';
import 'package:pocketa/src/utils/appwrite/providers.dart';
import 'package:pocketa/src/utils/services/request_guard_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_repository.g.dart';

class AuthRepository {
  const AuthRepository(this.account, this.requestGuard);

  final Account account;
  final RequestGuard requestGuard;

  Future<void> logInWithEmail(String email, String password) async {
    return requestGuard.call(
      () async {
        await account.createEmailPasswordSession(
          email: email,
          password: password,
        );
      },
      possibleExceptions: const {
        CredentialsMismatchException(),
        SessionExistsException(),
      },
    );
  }

  Future<void> signUp(String username, String email, String password) {
    return requestGuard.call(() async {
      await account.create(
        userId: ID.unique(),
        email: email,
        password: password,
        name: username,
      );
      await account.createEmailPasswordSession(
        email: email,
        password: password,
      );
    }, possibleExceptions: const {EmailInUseException()});
  }

  Future<Auth?> getCurrentUser() async {
    try {
      return requestGuard.call(() async {
        final user = await account.get();
        return Auth(email: user.email, name: user.name);
      }, invalidateOnSessionRequired: false);
    } on SessionRequiredException {
      return null;
    }
  }
}

@riverpod
AuthRepository authRepository(Ref ref) {
  final account = ref.read(appwriteAccountProvider);
  final requestGuard = ref.read(requestGuardServiceProvider);
  return AuthRepository(account, requestGuard);
}
