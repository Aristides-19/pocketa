import 'package:pocketa/src/localization/locale.dart';
import 'package:pocketa/src/utils/app_exception.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// [AppException] Wrapper for Exceptions thrown by Supabase Database API [PostgrestException]
abstract class AppPGException implements AppException<PostgrestException> {
  const AppPGException();

  /// Checks if the exception matches a waiting [PostgrestException].
  @override
  bool matches(PostgrestException e);
}

/// An exception thrown when a uniqueness violation occurs in the database.
/// - The [matches] method checks for the `23505` error code.
class UniquenessViolationException extends AppPGException {
  const UniquenessViolationException();

  @override
  bool matches(PostgrestException e) => e.code == '23505';
  @override
  String title() => '';
  @override
  String message() => '';
}

/// An exception thrown when an unauthorized action is attempted in the database.
/// This can occur when the user does not have RLS or granted permissions for the action.
/// It should not occur if the Supabase policies are set up correctly.
/// - The [matches] method checks for the `42501` error code.
class UnauthorizedException extends AppPGException {
  const UnauthorizedException();

  @override
  bool matches(PostgrestException e) => e.code == '42501';
  @override
  String title() => LocaleKeys.errors_unauthorized_title.tr();
  @override
  String message() => LocaleKeys.errors_unauthorized_message.tr();
}

/// An exception thrown when a rate limit is exceeded in the database.
/// - The [matches] method checks for the `429` error code.
class RateLimitPGException extends AppPGException {
  const RateLimitPGException();

  @override
  bool matches(PostgrestException e) => e.code == '429';
  @override
  String title() => LocaleKeys.errors_rate_limit_title.tr();
  @override
  String message() => LocaleKeys.errors_rate_limit_message.tr();
}

/// An exception thrown when a requested row is not found in the database.
/// This can occur when using `.single()` methods and no rows or multiple are returned.
/// - The [matches] method checks for the `PGRST116` error code.
class RowNotFoundException extends AppPGException {
  const RowNotFoundException();

  @override
  bool matches(PostgrestException e) => e.code == 'PGRST116';
  @override
  String title() => LocaleKeys.errors_row_not_found_title.tr();
  @override
  String message() => LocaleKeys.errors_row_not_found_message.tr();
}

/// When calling RPCs, this exception is thrown when no data is found.
/// - The [matches] method checks for the `P0002` error code.
class RPCNoDataFoundException extends AppPGException {
  const RPCNoDataFoundException();

  @override
  bool matches(PostgrestException e) => e.code == 'P0002';
  @override
  String title() => LocaleKeys.errors_row_not_found_title.tr();
  @override
  String message() => LocaleKeys.errors_row_not_found_message.tr();
}

/// Equivalent to [UnknownException] but for PostgrestExceptions.
class UnknownPGException extends AppPGException {
  UnknownPGException(this._exception);

  final PostgrestException _exception;

  @override
  bool matches(PostgrestException e) => false;
  @override
  String title() => LocaleKeys.errors_unknown_title.tr();
  @override
  String message() =>
      '${_exception.toString()} ${LocaleKeys.errors_unknown_message.tr()}';
}
