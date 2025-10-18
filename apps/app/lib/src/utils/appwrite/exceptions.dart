import 'package:appwrite/appwrite.dart';
import 'package:pocketa/src/localization/locale.dart';

/// Base class for all Appwrite responses exceptions.
sealed class AppException implements Exception {
  const AppException();

  /// Checks if the exception matches a waiting AppwriteException.
  bool matches(AppwriteException e);
  String title();
  String message();
}

class CredentialsMismatchException extends AppException {
  const CredentialsMismatchException();
  @override
  bool matches(AppwriteException e) => e.type == 'user_invalid_credentials';
  @override
  String title() => LocaleKeys.errors_credentials_mismatch_title.tr();
  @override
  String message() => LocaleKeys.errors_credentials_mismatch_message.tr();
}

class EmailInUseException extends AppException {
  const EmailInUseException();
  static const _types = ['user_already_exists', 'user_email_already_exists'];
  @override
  bool matches(AppwriteException e) => _types.contains(e.type);
  @override
  String title() => LocaleKeys.errors_email_in_use_title.tr();
  @override
  String message() => LocaleKeys.errors_email_in_use_message.tr();
}

class SessionExistsException extends AppException {
  const SessionExistsException();
  @override
  bool matches(AppwriteException e) => e.type == 'user_session_already_exists';
  @override
  String title() => LocaleKeys.errors_session_exists_title.tr();
  @override
  String message() => LocaleKeys.errors_session_exists_message.tr();
}

class SessionNotFoundException extends AppException {
  const SessionNotFoundException();
  @override
  bool matches(AppwriteException e) => e.type == 'user_session_not_found';
  @override
  String title() => LocaleKeys.errors_session_not_found_title.tr();
  @override
  String message() => LocaleKeys.errors_session_not_found_message.tr();
}

class SessionRequiredException extends AppException {
  const SessionRequiredException();
  @override
  bool matches(AppwriteException e) => e.type == 'general_unauthorized_scope';
  @override
  String title() => LocaleKeys.errors_session_required_title.tr();
  @override
  String message() => LocaleKeys.errors_session_required_message.tr();
}

class UnauthorizedException extends AppException {
  const UnauthorizedException();
  @override
  bool matches(AppwriteException e) => e.type == 'user_unauthorized';
  @override
  String title() => LocaleKeys.errors_unauthorized_title.tr();
  @override
  String message() => LocaleKeys.errors_unauthorized_message.tr();
}

class RowUpdateConflictException extends AppException {
  const RowUpdateConflictException();
  @override
  bool matches(AppwriteException e) => e.type == 'row_update_conflict';
  @override
  String title() => LocaleKeys.errors_row_update_conflict_title.tr();
  @override
  String message() => LocaleKeys.errors_row_update_conflict_message.tr();
}

class RowNotFoundException extends AppException {
  const RowNotFoundException();
  @override
  bool matches(AppwriteException e) => e.type == 'row_not_found';
  @override
  String title() => LocaleKeys.errors_row_not_found_title.tr();
  @override
  String message() => LocaleKeys.errors_row_not_found_message.tr();
}

class NetworkException extends AppException {
  const NetworkException();

  @override
  bool matches(AppwriteException e) {
    final msg = e.message?.toLowerCase() ?? '';
    return msg.contains('socketexception') || msg.contains('clientexception');
  }

  @override
  String title() => LocaleKeys.errors_network_title.tr();
  @override
  String message() => LocaleKeys.errors_network_message.tr();
}

class RateLimitException extends AppException {
  const RateLimitException();
  @override
  bool matches(AppwriteException e) =>
      e.code == 429 || e.type == 'general_rate_limit_exceeded';
  @override
  String title() => LocaleKeys.errors_rate_limit_title.tr();
  @override
  String message() => LocaleKeys.errors_rate_limit_message.tr();
}

class UnknownException extends AppException {
  const UnknownException(this._unknownMessage);

  final String _unknownMessage;
  @override
  bool matches(AppwriteException e) => false;
  @override
  String title() => LocaleKeys.errors_unknown_title.tr();
  @override
  String message() => _unknownMessage + LocaleKeys.errors_unknown_message.tr();
}
