import 'package:appwrite/appwrite.dart';
import 'package:collection/collection.dart';
import 'package:logger/logger.dart';
import 'package:pocketa/src/features/auth/auth.dart';
import 'package:pocketa/src/utils/appwrite/exceptions.dart';
import 'package:pocketa/src/utils/services/logger_service.dart';
import 'package:pocketa/src/utils/services/toaster_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'request_guard_service.g.dart';

class RequestGuard {
  const RequestGuard(this.ref, this.logger, this.toaster);

  final Toaster toaster;
  final Logger logger;
  final Ref ref;

  /// Maps a function that may throw an [AppwriteException] to a custom [AppException].
  Future<T> call<T>(
    Future<T> Function() callAsync, {
    Set<AppException> possibleExceptions = const {},
    bool invalidateOnSessionRequired = true,
  }) async {
    try {
      return await callAsync();
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

  Future<T> callToaster<T>(
    Future<T> Function() callAsync, {
    Set<AppException> possibleExceptions = const {},
    bool invalidateOnSessionRequired = true,
  }) async {
    try {
      return await call(
        callAsync,
        possibleExceptions: possibleExceptions,
        invalidateOnSessionRequired: invalidateOnSessionRequired,
      );
    } on AppException catch (e) {
      if (invalidateOnSessionRequired || e is! SessionRequiredException) {
        switch (e) {
          case UnknownException _:
            toaster.add(
              ToasterMode.error,
              e.title(),
              e.unknownMessage + e.message(),
            );
            break;
          default:
            toaster.add(ToasterMode.error, e.title(), e.message());
        }
      }
      rethrow;
    }
  }
}

@Riverpod(keepAlive: true)
RequestGuard requestGuardService(Ref ref) {
  return RequestGuard(
    ref,
    ref.read(loggerServiceProvider),
    ref.read(toasterServiceProvider),
  );
}
