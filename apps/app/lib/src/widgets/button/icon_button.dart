import 'package:flutter/material.dart';

class PIconButton extends StatelessWidget {
  const PIconButton({
    super.key,
    required this.icon,
    required this.onPressed,
    required this.tooltip,
    this.isLoading = false,
    this.iconSize = 18,
  });

  final Widget icon;
  final VoidCallback onPressed;
  final String tooltip;
  final double iconSize;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: icon,
      onPressed: isLoading ? null : onPressed,
      tooltip: tooltip,
      iconSize: iconSize,
      constraints: BoxConstraints(
        minWidth: iconSize * 2,
        minHeight: iconSize * 2,
      ),
    );
  }
}
