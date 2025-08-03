import 'package:flutter/material.dart';
import 'package:pocketa/src/constants/constants.dart';

class LabelButton extends StatelessWidget {
  const LabelButton({super.key, required this.label, required this.onPressed});

  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        shape: const RoundedRectangleBorder(
          borderRadius: AppTheme.borderRadius,
        ),
      ),
      child: Text(label, style: textTheme.titleMedium),
    );
  }
}
