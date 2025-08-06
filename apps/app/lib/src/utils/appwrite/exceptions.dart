import 'package:appwrite/appwrite.dart';

/// Base class for all Appwrite responses exceptions.
/// UI should catch it and show a i18n message.
sealed class AppException implements Exception {
  const AppException();

  /// Checks if the exception matches a waiting AppwriteException.
  bool matches(AppwriteException e);
}

class CredentialsMismatchException extends AppException {
  const CredentialsMismatchException();
  @override
  bool matches(AppwriteException e) => e.type == 'user_invalid_credentials';
}

class EmailInUseException extends AppException {
  const EmailInUseException();
  static const _types = ['user_already_exists', 'user_email_already_exists'];
  @override
  bool matches(AppwriteException e) => _types.contains(e.type);
}

class SessionExistsException extends AppException {
  const SessionExistsException();
  @override
  bool matches(AppwriteException e) => e.type == 'user_session_already_exists';
}

class SessionNotFoundException extends AppException {
  const SessionNotFoundException();
  @override
  bool matches(AppwriteException e) => e.type == 'user_session_not_found';
}

class SessionRequiredException extends AppException {
  const SessionRequiredException();
  @override
  bool matches(AppwriteException e) => e.type == 'general_unauthorized_scope';
}

class UnauthorizedException extends AppException {
  const UnauthorizedException();
  @override
  bool matches(AppwriteException e) => e.type == 'user_unauthorized';
}

class NetworkException extends AppException {
  const NetworkException();

  @override
  bool matches(AppwriteException e) {
    final msg = e.message?.toLowerCase() ?? '';
    return msg.contains('socketexception') || msg.contains('clientexception');
  }
}

class RateLimitException extends AppException {
  const RateLimitException();
  @override
  bool matches(AppwriteException e) =>
      e.code == 429 || e.type == 'general_rate_limit_exceeded';
}

class UnknownException extends AppException {
  const UnknownException(this.message);

  final String message;
  @override
  bool matches(AppwriteException e) => false;
}
