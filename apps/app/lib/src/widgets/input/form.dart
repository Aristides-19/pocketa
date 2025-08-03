import 'package:flutter/material.dart';

/// Children must include [FormInput] widgets and Submit Button. For full screens.
class AppForm extends StatelessWidget {
  const AppForm({super.key, required this.formKey, required this.children});

  final GlobalKey<FormState> formKey;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final height = mediaQuery.size.height - mediaQuery.padding.bottom;

    return Form(
      key: formKey,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxHeight: height),
        child: AutofillGroup(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 33, vertical: 65),
            physics: const ClampingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: children,
            ),
          ),
        ),
      ),
    );
  }
}
