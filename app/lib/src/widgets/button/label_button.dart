import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:pocketa/src/constants/constants.dart';

class LabelButton extends StatelessWidget {
  const LabelButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.isLoading = false,
    this.color,
    this.showLoading = false,
  });

  final String label;
  final VoidCallback onPressed;
  final bool isLoading;
  final Color? color;
  final bool showLoading;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    return TextButton(
      onPressed: isLoading ? null : onPressed,
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        shape: const RoundedRectangleBorder(
          borderRadius: AppTheme.borderRadius,
        ),
      ),
      child: isLoading && showLoading
          ? LoadingAnimationWidget.progressiveDots(
              color: color ?? theme.colorScheme.onSurface,
              size: 20,
            )
          : Text(label, style: textTheme.titleMedium!.copyWith(color: color)),
    );
  }
}
