import 'package:appwrite/appwrite.dart';
import 'package:collection/collection.dart';
import 'package:logger/logger.dart';
import 'package:pocketa/src/utils/appwrite/exceptions.dart';
import 'package:pocketa/src/utils/services/logger_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'request_guard_service.g.dart';

class RequestGuard {
  const RequestGuard(this.ref, this.logger);

  final Logger logger;
  final Ref ref;

  /// Maps a function that may throw an [AppwriteException] to a custom [AppException].
  Future<T> call<T>(
    Future<T> Function() funcAsync, {
    Set<AppException> exceptions = const {},
  }) async {
    try {
      return await funcAsync();
    } on AppwriteException catch (e) {
      logger.e('Appwrite call failed', error: e);
      const defaultExceptions = {
        SessionRequiredException(),
        NetworkException(),
        RateLimitException(),
        UnauthorizedException(),
        RowNotFoundException(),
        RowUpdateConflictException(),
      };
      final allExceptions = {...exceptions, ...defaultExceptions};

      final matchedException = allExceptions.firstWhereOrNull(
        (exception) => exception.matches(e),
      );

      if (matchedException != null) throw matchedException;

      throw UnknownException(e.message ?? 'An unknown error occurred.');
    } on Exception catch (e) {
      logger.e('Non-Appwrite exception occurred', error: e);
      throw UnknownException(e.toString());
    }
  }
}

@Riverpod(keepAlive: true)
RequestGuard reqGuard(Ref ref) {
  return RequestGuard(ref, ref.read(loggerProvider));
}
