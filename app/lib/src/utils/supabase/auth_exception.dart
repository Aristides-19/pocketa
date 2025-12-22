import 'package:pocketa/src/localization/locale.dart';
import 'package:pocketa/src/utils/app_exception.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// [AppException] Wrapper for Exceptions thrown by Supabase Auth API [AuthException]
abstract class AppAuthException implements AppException<AuthException> {
  const AppAuthException();

  /// Checks if the exception matches a waiting [AuthException].
  @override
  bool matches(AuthException e);
}

/// An exception thrown when an email is already in use during sign-up.
/// - The [matches] method checks for the `email_exists` and `user_already_exists` error codes.
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

/// An exception thrown when an email has not been confirmed yet during login.
/// - The [matches] method checks for the `email_not_confirmed` error code.
class EmailNotConfirmedException extends AppAuthException {
  const EmailNotConfirmedException();

  @override
  bool matches(AuthException e) => e.code == 'email_not_confirmed';
  @override
  String title() => '';
  @override
  String message() => '';
}

/// An exception thrown when provided credentials do not match any user in login.
/// - The [matches] method checks for the `invalid_credentials` error code.
class CredentialsMismatchException extends AppAuthException {
  const CredentialsMismatchException();

  @override
  bool matches(AuthException e) => e.code == 'invalid_credentials';
  @override
  String title() => LocaleKeys.errors_credentials_mismatch_title.tr();
  @override
  String message() => LocaleKeys.errors_credentials_mismatch_message.tr();
}

/// An exception thrown when the new password is the same as the old password during a password change.
/// - The [matches] method checks for the `same_password` error code.
class SamePasswordException extends AppAuthException {
  const SamePasswordException();

  @override
  bool matches(AuthException e) => e.code == 'same_password';
  @override
  String title() => '';
  @override
  String message() => '';
}

/// An exception thrown when sign-ups are disabled for the project.
/// - The [matches] method checks for the `signup_disabled` error code.
class SignUpDisabledException extends AppAuthException {
  const SignUpDisabledException();

  @override
  bool matches(AuthException e) => e.code == 'signup_disabled';
  @override
  String title() => '';
  @override
  String message() => '';
}

/// An exception thrown when a provided password is considered weak during sign-up or password change.
/// - The [matches] method checks for the `weak_password` error code or [AuthWeakPasswordException].
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

/// An exception thrown when there is no valid session during an authenticated action.
/// - The [matches] method checks for [AuthSessionMissingException].
class SessionMissingException extends AppAuthException {
  const SessionMissingException();

  @override
  bool matches(AuthException e) => e is AuthSessionMissingException;
  @override
  String title() => '';
  @override
  String message() => '';
}

/// An exception thrown when a rate limit is exceeded in authentication requests.
/// - The [matches] method checks for the `over_request_rate_limit` error code.
class RateLimitException extends AppAuthException {
  const RateLimitException();

  @override
  bool matches(AuthException e) => e.code == 'over_request_rate_limit';
  @override
  String title() => LocaleKeys.errors_rate_limit_title.tr();
  @override
  String message() => LocaleKeys.errors_rate_limit_message.tr();
}

/// An exception thrown when a request times out.
/// - The [matches] method checks for the `request_timeout` error code.
class TimeoutException extends AppAuthException {
  const TimeoutException();

  @override
  bool matches(AuthException e) => e.code == 'request_timeout';
  @override
  String title() => '';
  @override
  String message() => '';
}

/// An exception thrown when there is a network issue during an authentication request.
/// - The [matches] method checks for [AuthRetryableFetchException].
class AuthNetworkException extends AppAuthException {
  const AuthNetworkException();

  @override
  bool matches(AuthException e) => e is AuthRetryableFetchException;
  @override
  String title() => LocaleKeys.errors_network_title.tr();
  @override
  String message() => LocaleKeys.errors_network_message.tr();
}

/// Equivalent to [UnknownException] but for AuthExceptions.
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
