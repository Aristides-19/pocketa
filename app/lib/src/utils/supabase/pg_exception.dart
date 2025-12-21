import 'package:pocketa/src/localization/locale.dart';
import 'package:pocketa/src/utils/app_exception.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract class AppPGException implements AppException<PostgrestException> {
  const AppPGException();

  /// Checks if the exception matches a waiting [PostgrestException].
  @override
  bool matches(PostgrestException e);
}

class UniquenessViolationException extends AppPGException {
  const UniquenessViolationException();

  @override
  bool matches(PostgrestException e) => e.code == '23505';
  @override
  String title() => '';
  @override
  String message() => '';
}

class UnauthorizedException extends AppPGException {
  const UnauthorizedException();

  @override
  bool matches(PostgrestException e) => e.code == '42501';
  @override
  String title() => LocaleKeys.errors_unauthorized_title.tr();
  @override
  String message() => LocaleKeys.errors_unauthorized_message.tr();
}

class RateLimitPGException extends AppPGException {
  const RateLimitPGException();

  @override
  bool matches(PostgrestException e) => e.code == '429';
  @override
  String title() => LocaleKeys.errors_rate_limit_title.tr();
  @override
  String message() => LocaleKeys.errors_rate_limit_message.tr();
}

class RowNotFoundException extends AppPGException {
  const RowNotFoundException();

  @override
  bool matches(PostgrestException e) => e.code == 'PGRST116';
  @override
  String title() => LocaleKeys.errors_row_not_found_title.tr();
  @override
  String message() => LocaleKeys.errors_row_not_found_message.tr();
}

class RPCNoDataFoundException extends AppPGException {
  const RPCNoDataFoundException();

  @override
  bool matches(PostgrestException e) => e.code == 'P0002';
  @override
  String title() => LocaleKeys.errors_row_not_found_title.tr();
  @override
  String message() => LocaleKeys.errors_row_not_found_message.tr();
}

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
