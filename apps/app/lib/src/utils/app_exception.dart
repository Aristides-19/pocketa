import 'dart:io';

import 'package:pocketa/src/localization/locale.dart';

abstract class AppException<T extends Exception> implements Exception {
  const AppException();

  /// Checks if the exception matches a waiting [T].
  bool matches(T e);
  String title();
  String message();
}

class NetworkException extends AppException {
  const NetworkException();

  @override
  bool matches(Exception e) => e is SocketException || e is HttpException;
  @override
  String title() => LocaleKeys.errors_network_title.tr();
  @override
  String message() => LocaleKeys.errors_network_message.tr();
}

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
