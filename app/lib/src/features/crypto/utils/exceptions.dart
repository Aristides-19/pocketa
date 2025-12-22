import 'package:pocketa/src/localization/locale.dart';
import 'package:pocketa/src/utils/app_exception.dart';

/// An exception indicating that a password is required for encryption.
/// It serves as a signal to redirect the user to login screen.
class PasswordRequiredException extends AppException<Exception> {
  const PasswordRequiredException();
  @override
  bool matches(Exception e) => false;
  @override
  String title() => LocaleKeys.errors_password_required_title.tr();
  @override
  String message() => LocaleKeys.errors_password_required_message.tr();
}
