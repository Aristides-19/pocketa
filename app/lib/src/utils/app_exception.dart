import 'dart:io';

import 'package:pocketa/src/localization/locale.dart';

/// A Wrapper for exceptions, any exception thrown in the app should implement this.
/// - Contains a [title] and a [message] to display to the user, intended to be used with localization.
/// - The [matches] method is used to check if the exception matches a specific type of exception [T].
abstract class AppException<T extends Exception> implements Exception {
  const AppException();

  /// Checks if the exception matches a waiting [T].
  bool matches(T e);
  String title();
  String message();
}

/// An exception thrown when there is any network issue.
/// - The [matches] method checks for [SocketException] and [HttpException].
class NetworkException extends AppException {
  const NetworkException();

  @override
  bool matches(Exception e) => e is SocketException || e is HttpException;
  @override
  String title() => LocaleKeys.errors_network_title.tr();
  @override
  String message() => LocaleKeys.errors_network_message.tr();
}

/// An exception thrown when an unknown error occurs.
/// Normally, there would be a number of checks for specific exceptions,
/// this would be the fallback exception.
class UnknownException implements AppException {
  const UnknownException(this._unknownException);

  final Exception _unknownException;

  @override
  bool matches(Exception e) => true;
  @override
  String title() => LocaleKeys.errors_unknown_title.tr();
  @override
  String message() =>
      '${_unknownException.toString()} ${LocaleKeys.errors_unknown_message.tr()}';
}
