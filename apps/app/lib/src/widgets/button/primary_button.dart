import 'package:flutter/material.dart';
import 'package:pocketa/src/constants/constants.dart';

class Button extends StatelessWidget {
  const Button({
    super.key,
    required this.label,
    required this.onPressed,
    this.width = 160,
  });

  final String label;
  final VoidCallback onPressed;
  final double width;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Container(
      decoration: BoxDecoration(
        borderRadius: AppTheme.borderRadius,
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.primary.withAlpha(100),
            blurRadius: 100,
            spreadRadius: 5,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: FilledButton(
        onPressed: onPressed,
        style: FilledButton.styleFrom(
          minimumSize: Size(width, 60),
          backgroundColor: theme.colorScheme.primary,
          shape: const RoundedRectangleBorder(
            borderRadius: AppTheme.borderRadius,
          ),
        ),
        child: Text(
          label,
          style: textTheme.titleMedium!.copyWith(
            color: theme.colorScheme.onPrimary,
            fontSize: 20,
          ),
        ),
      ),
    );
  }
}
