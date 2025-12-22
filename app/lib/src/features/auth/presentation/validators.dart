import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart'
    show FormBuilderValidators;
import 'package:pocketa/src/localization/locale.dart';

typedef V = FormBuilderValidators;

String? Function(String?) emailValidator() =>
    V.compose([V.required(), V.email()]);

String? Function(String?) loginPasswordValidator() =>
    V.compose([V.required(), V.minLength(8), V.maxLength(30)]);

String? Function(String?) signupPasswordValidator() => V.compose([
  V.required(),
  V.password(maxLength: 30, minSpecialCharCount: 0),
]);

String? Function(String?) confirmPasswordValidator(
  GlobalKey<FormBuilderState> formKey,
) => V.compose([
  V.required(),
  (value) {
    final password = formKey.currentState?.fields['password']?.value;
    if (value != password) return LocaleKeys.auth_password_not_match.tr();
    return null;
  },
]);

String? Function(String?) usernameValidator() =>
    V.compose([V.required(), V.username(maxLength: 20)]);
