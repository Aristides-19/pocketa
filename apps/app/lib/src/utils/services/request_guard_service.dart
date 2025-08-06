import 'package:appwrite/appwrite.dart';
import 'package:collection/collection.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:pocketa/src/features/auth/auth.dart';
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
    Future<T> Function() call, {
    Set<AppException> possibleExceptions = const {},
    bool invalidateOnSessionRequired = true,
  }) async {
    try {
      return await call();
    } on AppwriteException catch (e) {
      logger.e('Appwrite call failed', error: e);
      const defaultExceptions = {
        SessionRequiredException(),
        NetworkException(),
        RateLimitException(),
      };
      final allExceptions = {...possibleExceptions, ...defaultExceptions};

      final matchedException = allExceptions.firstWhereOrNull(
        (exception) => exception.matches(e),
      );

      if (matchedException is SessionRequiredException &&
          invalidateOnSessionRequired) {
        ref.invalidate(authServiceProvider);
      }

      if (matchedException != null) throw matchedException;

      throw UnknownException(e.message ?? 'An unknown error occurred.');
    }
  }
}

@Riverpod(keepAlive: true)
RequestGuard requestGuardService(Ref ref) {
  return RequestGuard(ref, ref.read(loggerServiceProvider));
}
