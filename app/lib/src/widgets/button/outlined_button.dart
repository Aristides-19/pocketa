import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:pocketa/src/constants/constants.dart';

class POutlinedButton extends StatelessWidget {
  /// Button that displays an outlined button and handles tap events.
  /// It is not required to set disabled to true when loading, as loading will automatically disable the button.
  /// - [disabled] indicates whether the button is disabled. It will not respond to taps, and will decrease its opacity.
  /// - [loading] indicates whether to show a loading animation instead of the label. It will not respond to taps while loading.
  const POutlinedButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.width = 160,
    this.height = 60,
    this.fontSize = 20,
    this.loading = false,
    this.disabled = false,
  });

  final String label;
  final VoidCallback onPressed;
  final double width;
  final double height;
  final double fontSize;
  final bool loading;
  final bool disabled;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return OutlinedButton(
      onPressed: loading || disabled ? null : onPressed,
      style: OutlinedButton.styleFrom(
        minimumSize: Size(width, height),
        side: BorderSide(color: theme.colorScheme.primary, width: 2),
        shape: const RoundedRectangleBorder(
          borderRadius: AppTheme.borderRadius,
        ),
      ),
      child: loading
          ? LoadingAnimationWidget.progressiveDots(
              color: theme.colorScheme.onPrimary,
              size: height / 2,
            )
          : Opacity(
              opacity: disabled ? 0.7 : 1.0,
              child: Text(
                label,
                style: textTheme.titleMedium!.copyWith(
                  color: theme.colorScheme.primary,
                  fontSize: fontSize,
                ),
              ),
            ),
    );
  }
}
