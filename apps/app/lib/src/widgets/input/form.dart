import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:pocketa/src/widgets/widgets.dart';

/// Children must include [FormInput] widgets and Submit Button. For full screens.
class AppForm extends StatelessWidget {
  const AppForm({super.key, required this.formKey, required this.children});

  final GlobalKey<FormBuilderState> formKey;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return FormBuilder(
      key: formKey,
      child: AutofillGroup(
        child: ScrollableScreen(
          padding: const EdgeInsets.symmetric(horizontal: 33, vertical: 65),
          children: children,
        ),
      ),
    );
  }
}
