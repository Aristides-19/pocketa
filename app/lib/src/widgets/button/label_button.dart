import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:pocketa/src/constants/constants.dart';

class LabelButton extends StatelessWidget {
  /// Button that displays a text label and handles tap events.
  /// It is not required to set disabled to true when loading, as loading will automatically disable the button.
  /// - `[disabled]` indicates whether the button is disabled. It will not respond to taps, and will decrease its opacity.
  /// - `[loading]` indicates whether to show a loading animation instead of the label. It will not respond to taps while loading.
  /// - `[color]` sets the text color of the label. Default to `[onSurface]` color from the theme.
  const LabelButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.disabled = false,
    this.color,
    this.loading = false,
  });

  final String label;
  final VoidCallback onPressed;
  final bool disabled;
  final Color? color;
  final bool loading;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return TextButton(
      onPressed: disabled || loading ? null : onPressed,
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        shape: const RoundedRectangleBorder(
          borderRadius: AppTheme.borderRadius,
        ),
      ),
      child: loading
          ? LoadingAnimationWidget.progressiveDots(
              color: color ?? theme.colorScheme.onSurface,
              size: 20,
            )
          : Opacity(
              opacity: disabled ? 0.7 : 1.0,
              child: Text(
                label,
                style: textTheme.titleMedium!.copyWith(color: color),
              ),
            ),
    );
  }
}
