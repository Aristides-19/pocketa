import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

/// Generic switcher widget that can be reused across the app. State is managed.
class Switcher extends HookWidget {
  const Switcher({
    super.key,
    required this.value,
    required this.onChanged,
    this.switchScale = 0.8,
  });

  final ValueNotifier<bool> value;
  final Function(bool) onChanged;
  final double switchScale;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final outline = theme.colorScheme.outline.withAlpha(175);
    return SizedBox(
      width: 50 * switchScale,
      height: 28 * switchScale,
      child: Transform.scale(
        scale: switchScale,
        child: Switch(
          value: value.value,
          onChanged: (newValue) {
            value.value = newValue;
            onChanged(newValue);
          },
          thumbColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return theme.colorScheme.onPrimary;
            }
            return outline;
          }),
          trackColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return theme.colorScheme.primary;
            }
            return theme.colorScheme.surface;
          }),
          trackOutlineColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return theme.colorScheme.primary;
            }
            return outline;
          }),
        ),
      ),
    );
  }
}
