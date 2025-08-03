import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pocketa/src/constants/constants.dart';

class FormInput extends HookWidget {
  const FormInput({
    super.key,
    required this.label,
    required this.keyboardType,
    required this.textInputAction,
    required this.autofillHints,
    this.isPassword = false,
    this.maxLength,
    this.validator,
    this.controller,
  });

  final String label;
  final TextInputType keyboardType;
  final TextInputAction textInputAction;
  final List<String> autofillHints;
  final bool isPassword;
  final int? maxLength;
  final FormFieldValidator<String>? validator;
  final TextEditingController? controller;

  @override
  Widget build(BuildContext context) {
    final isObscured = useState(isPassword);
    final iconTheme = IconTheme.of(context);

    return TextFormField(
      keyboardType: keyboardType,
      controller: controller,
      textInputAction: textInputAction,
      autofillHints: autofillHints,
      obscureText: isObscured.value,
      maxLength: maxLength,
      onTapOutside: (_) => FocusScope.of(context).unfocus(),
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: validator,

      decoration: InputDecoration(
        border: const OutlineInputBorder(borderRadius: AppTheme.borderRadius),
        labelText: label,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 18,
        ),

        suffixIcon: isPassword
            ? IconButton(
                icon: FaIcon(
                  isObscured.value
                      ? FontAwesomeIcons.eyeSlash
                      : FontAwesomeIcons.eye,
                  size: iconTheme.size,
                  color: iconTheme.color,
                ),
                onPressed: () => isObscured.value = !isObscured.value,
              )
            : null,
      ),
    );
  }
}
