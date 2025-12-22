import 'package:collection/collection.dart';
import 'package:logger/logger.dart';
import 'package:pocketa/src/utils/app_exception.dart';
import 'package:pocketa/src/utils/services/logger_provider.dart';
import 'package:pocketa/src/utils/supabase/supabase.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'supabase_handler.g.dart';

class SupabaseHandler {
  const SupabaseHandler(this.ref, this.logger);

  final Logger logger;
  final Ref ref;

  /// Checks for non-Supabase typed exceptions and manages them.
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

  /// Calls any function and handles exceptions. Ideal for calls outside of Postgrest or Auth Supabase API.
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

  /// Calls a Supabase Auth function and handles exceptions.
  /// - It will check for [exceptions] provided first, then the default ones.
  /// - If no match is found, it will throw [UnknownAuthException].
  /// - If there are no [AuthException]s, it will be mapped to [UnknownException] or [NetworkException] if applies.
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

  /// Calls a Supabase Postgrest function and handles exceptions.
  /// - It will check for [exceptions] provided first, then the default ones.
  /// - If no match is found, it will throw [UnknownPGException].
  /// - If there are no [PostgrestException]s, it will be mapped to [UnknownException] or [NetworkException] if applies.
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

@Riverpod(keepAlive: true, name: r'$supabaseHandler')
SupabaseHandler supabaseHandler(Ref ref) {
  return SupabaseHandler(ref, ref.read($logger));
}
