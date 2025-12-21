import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:pocketa/src/localization/locale.dart';

String? Function(String?) emailValidator() => FormBuilderValidators.compose([
  FormBuilderValidators.required(),
  FormBuilderValidators.email(),
]);

String? Function(String?) loginPasswordValidator() =>
    FormBuilderValidators.compose([
      FormBuilderValidators.required(),
      FormBuilderValidators.minLength(8),
      FormBuilderValidators.maxLength(30),
    ]);

String? Function(String?) signupPasswordValidator() =>
    FormBuilderValidators.compose([
      FormBuilderValidators.required(),
      FormBuilderValidators.password(maxLength: 30, minSpecialCharCount: 0),
    ]);

String? Function(String?) confirmPasswordValidator(
  GlobalKey<FormBuilderState> formKey,
) => FormBuilderValidators.compose([
  FormBuilderValidators.required(),
  (value) {
    final password = formKey.currentState?.fields['password']?.value;
    if (value != password) return LocaleKeys.auth_password_not_match.tr();
    return null;
  },
]);

String? Function(String?) usernameValidator() => FormBuilderValidators.compose([
  FormBuilderValidators.required(),
  FormBuilderValidators.username(maxLength: 20),
]);
