import 'package:flutter/material.dart';

class PIconButton extends StatelessWidget {
  /// Button that displays an icon and handles tap events.
  /// - `[tooltip]` should be mandatory for accessibility.
  /// - `[disabled]` indicates whether the button is disabled. It will not respond to taps, and will decrease its opacity.
  const PIconButton({
    super.key,
    required this.icon,
    required this.onPressed,
    this.tooltip,
    this.iconSize = 18,
    this.disabled = false,
  });

  final Widget icon;
  final VoidCallback onPressed;
  final String? tooltip;
  final double iconSize;
  final bool disabled;

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: disabled ? 0.7 : 1.0,
      child: IconButton(
        icon: icon,
        onPressed: disabled ? null : onPressed,
        tooltip: tooltip,
        iconSize: iconSize,
        constraints: BoxConstraints(
          minWidth: iconSize * 2,
          minHeight: iconSize * 2,
        ),
      ),
    );
  }
}
