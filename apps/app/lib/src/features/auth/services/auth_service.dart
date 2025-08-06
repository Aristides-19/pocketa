import 'package:logger/logger.dart';
import 'package:pocketa/src/features/auth/auth.dart';
import 'package:pocketa/src/features/auth/repository/auth_repository.dart';
import 'package:pocketa/src/utils/services/logger_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_service.g.dart';

@Riverpod(keepAlive: true)
class AuthService extends _$AuthService {
  late Logger logger;

  @override
  Future<Auth?> build() async {
    logger = await ref.read(loggerServiceProvider);
    logger.i('AuthService initialized');
    return await ref.read(authRepositoryProvider).getCurrentUser();
  }
}
