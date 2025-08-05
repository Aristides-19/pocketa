import 'package:appwrite/appwrite.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
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
}

@riverpod
AuthRepository authRepository(Ref ref) {
  final account = ref.watch(appwriteAccountProvider);
  return AuthRepository(account);
}
