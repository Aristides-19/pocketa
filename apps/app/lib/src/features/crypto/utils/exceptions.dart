import 'package:pocketa/src/localization/locale.dart';
import 'package:pocketa/src/utils/appwrite/exceptions.dart';

class PasswordRequiredException extends AppException {
  const PasswordRequiredException();

  @override
  String title() => LocaleKeys.errors_password_required_title.tr();
  @override
  String message() => LocaleKeys.errors_password_required_message.tr();
}
