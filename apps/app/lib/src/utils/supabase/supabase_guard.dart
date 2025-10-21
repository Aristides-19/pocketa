import 'package:collection/collection.dart';
import 'package:logger/logger.dart';
import 'package:pocketa/src/utils/app_exception.dart';
import 'package:pocketa/src/utils/services/logger_service.dart';
import 'package:pocketa/src/utils/supabase/supabase.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'supabase_guard.g.dart';

class SupabaseGuard {
  const SupabaseGuard(this.ref, this.logger);

  final Logger logger;
  final Ref ref;

  void _manageException(Exception e) {
    if (e is AppException) {
      logger.e('Non-Supabase App exception occurred', error: e);
      throw e;
    }
    const networkException = NetworkException();
    if (networkException.matches(e)) {
      logger.e('Supabase network exception occurred', error: e);
      throw networkException;
    }
    logger.e('Non-Supabase exception occurred', error: e);
    throw UnknownException(e);
  }

  Future<T> call<T>(
    Future<T> Function() funcAsync, {
    Set<AppException> exceptions = const {},
  }) async {
    try {
      return await funcAsync();
    } on Exception catch (e) {
      _manageException(e);
      rethrow;
    } on Error catch (e) {
      logger.e('Programmer error occurred', error: e);
      rethrow;
    }
  }

  Future<T> callAuth<T>(
    Future<T> Function() funcAsync, {
    Set<AppAuthException> exceptions = const {},
  }) async {
    try {
      return await funcAsync();
    } on AuthException catch (e) {
      logger.e('Supabase auth call failed', error: e);
      const defaultExceptions = {
        AuthNetworkException(),
        RateLimitException(),
        TimeoutException(),
      };
      final allExceptions = {...exceptions, ...defaultExceptions};

      final matchedException = allExceptions.firstWhereOrNull(
        (exception) => exception.matches(e),
      );

      if (matchedException != null) throw matchedException;

      throw UnknownAuthException(e);
    } on Exception catch (e) {
      _manageException(e);
      rethrow;
    } on Error catch (e) {
      logger.e('Programmer error occurred', error: e);
      rethrow;
    }
  }

  Future<T> callPG<T>(
    Future<T> Function() funcAsync, {
    Set<AppPGException> exceptions = const {},
  }) async {
    try {
      return await funcAsync();
    } on PostgrestException catch (e) {
      logger.e('Supabase Postgrest call failed', error: e);
      const defaultExceptions = {
        RowNotFoundException(),
        UnauthorizedException(),
        RateLimitPGException(),
        UniquenessViolationException(),
      };
      final allExceptions = {...exceptions, ...defaultExceptions};

      final matchedException = allExceptions.firstWhereOrNull(
        (exception) => exception.matches(e),
      );

      if (matchedException != null) throw matchedException;

      throw UnknownPGException(e);
    } on Exception catch (e) {
      _manageException(e);
      rethrow;
    } on Error catch (e) {
      logger.e('Programmer error occurred', error: e);
      rethrow;
    }
  }
}

@Riverpod(keepAlive: true)
SupabaseGuard supGuard(Ref ref) {
  return SupabaseGuard(ref, ref.read(loggerProvider));
}
