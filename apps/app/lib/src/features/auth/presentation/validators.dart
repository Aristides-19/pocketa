import 'package:form_builder_validators/form_builder_validators.dart';

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

String? Function(String?) confirmPasswordValidator(String password) =>
    FormBuilderValidators.compose([
      FormBuilderValidators.required(),
      FormBuilderValidators.equal(password),
    ]);
