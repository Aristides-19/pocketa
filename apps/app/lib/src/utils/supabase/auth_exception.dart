import 'package:pocketa/src/localization/locale.dart';
import 'package:pocketa/src/utils/app_exception.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract class AppAuthException implements AppException<AuthException> {
  const AppAuthException();

  /// Checks if the exception matches a waiting [AuthException].
  @override
  bool matches(AuthException e);
}

class EmailInUseException extends AppAuthException {
  const EmailInUseException();

  @override
  bool matches(AuthException e) =>
      e.code == 'email_exists' || e.code == 'user_already_exists';
  @override
  String title() => LocaleKeys.errors_email_in_use_title.tr();
  @override
  String message() => LocaleKeys.errors_email_in_use_message.tr();
}

class EmailNotConfirmedException extends AppAuthException {
  const EmailNotConfirmedException();

  @override
  bool matches(AuthException e) => e.code == 'email_not_confirmed';
  @override
  String title() => '';
  @override
  String message() => '';
}

class CredentialsMismatchException extends AppAuthException {
  const CredentialsMismatchException();

  @override
  bool matches(AuthException e) => e.code == 'invalid_credentials';
  @override
  String title() => LocaleKeys.errors_credentials_mismatch_title.tr();
  @override
  String message() => LocaleKeys.errors_credentials_mismatch_message.tr();
}

class SamePasswordException extends AppAuthException {
  const SamePasswordException();

  @override
  bool matches(AuthException e) => e.code == 'same_password';
  @override
  String title() => '';
  @override
  String message() => '';
}

class SignUpDisabledException extends AppAuthException {
  const SignUpDisabledException();

  @override
  bool matches(AuthException e) => e.code == 'signup_disabled';
  @override
  String title() => '';
  @override
  String message() => '';
}

class WeakPasswordException extends AppAuthException {
  const WeakPasswordException();

  @override
  bool matches(AuthException e) =>
      e.code == 'weak_password' || e is AuthWeakPasswordException;
  @override
  String title() => '';
  @override
  String message() => '';
}

class SessionMissingException extends AppAuthException {
  const SessionMissingException();

  @override
  bool matches(AuthException e) => e is AuthSessionMissingException;
  @override
  String title() => '';
  @override
  String message() => '';
}

class RateLimitException extends AppAuthException {
  const RateLimitException();

  @override
  bool matches(AuthException e) => e.code == 'over_request_rate_limit';
  @override
  String title() => LocaleKeys.errors_rate_limit_title.tr();
  @override
  String message() => LocaleKeys.errors_rate_limit_message.tr();
}

class TimeoutException extends AppAuthException {
  const TimeoutException();

  @override
  bool matches(AuthException e) => e.code == 'request_timeout';
  @override
  String title() => '';
  @override
  String message() => '';
}

class AuthNetworkException extends AppAuthException {
  const AuthNetworkException();

  @override
  bool matches(AuthException e) => e is AuthRetryableFetchException;
  @override
  String title() => LocaleKeys.errors_network_title.tr();
  @override
  String message() => LocaleKeys.errors_network_message.tr();
}

class UnknownAuthException extends AppAuthException {
  UnknownAuthException(this._exception);

  final AuthException _exception;

  @override
  bool matches(AuthException e) => false;
  @override
  String title() => LocaleKeys.errors_unknown_title.tr();
  @override
  String message() =>
      '${_exception.toString()} ${LocaleKeys.errors_unknown_message.tr()}';
}
