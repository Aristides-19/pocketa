import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:pocketa/src/constants/constants.dart';

class POutlinedButton extends StatelessWidget {
  const POutlinedButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.width = 160,
    this.height = 60,
    this.fontSize = 20,
    this.isLoading = false,
  });

  final String label;
  final VoidCallback onPressed;
  final double width;
  final double height;
  final double fontSize;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return OutlinedButton(
      onPressed: isLoading ? null : onPressed,
      style: OutlinedButton.styleFrom(
        minimumSize: Size(width, height),
        side: BorderSide(color: theme.colorScheme.primary, width: 2),
        shape: const RoundedRectangleBorder(
          borderRadius: AppTheme.borderRadius,
        ),
      ),
      child: isLoading
          ? LoadingAnimationWidget.progressiveDots(
              color: theme.colorScheme.onPrimary,
              size: height / 2,
            )
          : Text(
              label,
              style: textTheme.titleMedium!.copyWith(
                color: theme.colorScheme.primary,
                fontSize: fontSize,
              ),
            ),
    );
  }
}
