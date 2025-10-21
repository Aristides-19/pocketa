import 'package:pocketa/src/localization/locale.dart';
import 'package:pocketa/src/utils/app_exception.dart';

class PasswordRequiredException extends AppException<Exception> {
  const PasswordRequiredException();
  @override
  bool matches(Exception e) => false;
  @override
  String title() => LocaleKeys.errors_password_required_title.tr();
  @override
  String message() => LocaleKeys.errors_password_required_message.tr();
}
