import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pocketa/src/constants/constants.dart';

class FormTextField extends HookWidget {
  const FormTextField({
    super.key,
    required this.label,
    required this.keyboardType,
    required this.textInputAction,
    required this.autofillHints,
    required this.name,
    this.obscure = false,
    this.maxLength,
    this.validator,
  });

  final String name;
  final String label;
  final TextInputType keyboardType;
  final TextInputAction textInputAction;
  final List<String> autofillHints;
  final bool obscure;
  final int? maxLength;
  final FormFieldValidator<String>? validator;

  @override
  Widget build(BuildContext context) {
    final isObscured = useState(obscure);
    final iconTheme = IconTheme.of(context);

    return FormBuilderTextField(
      name: name,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      autofillHints: autofillHints,
      obscureText: isObscured.value,
      maxLength: maxLength,
      onTapOutside: (_) => FocusScope.of(context).unfocus(),
      autovalidateMode: .onUserInteraction,
      validator: validator,

      decoration: InputDecoration(
        border: const OutlineInputBorder(borderRadius: AppTheme.borderRadius),
        labelText: label,
        contentPadding: const .symmetric(horizontal: 20, vertical: 18),

        suffixIcon: obscure
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
