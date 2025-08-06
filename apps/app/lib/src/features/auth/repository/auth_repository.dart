import 'package:appwrite/appwrite.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pocketa/src/features/auth/auth.dart';
import 'package:pocketa/src/utils/appwrite/exceptions.dart';
import 'package:pocketa/src/utils/appwrite/providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_repository.g.dart';

class AuthRepository {
  AuthRepository(this.account);

  final Account account;

  Future<void> logInWithEmail(String email, String password) async {
    return guardCall(
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

  Future<Auth?> getCurrentUser() async {
    try {
      return await guardCall(() async {
        final user = await account.get();
        return Auth(email: user.email, name: user.name);
      });
    } on SessionRequiredException {
      return null;
    }
  }
}

@riverpod
AuthRepository authRepository(Ref ref) {
  final account = ref.watch(appwriteAccountProvider);
  return AuthRepository(account);
}
