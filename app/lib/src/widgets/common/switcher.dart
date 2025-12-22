import 'package:flutter/material.dart';

/// Generic switcher widget that can be reused across the app.
/// It is a stateless (controlled) widget that reflects the [enabled] state
/// and notifies changes via [onChanged].
class Switcher extends StatelessWidget {
  const Switcher({
    super.key,
    required this.enabled,
    required this.onChanged,
    this.switchScale = 0.8,
  });

  final bool enabled;
  final ValueChanged<bool> onChanged;
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
          value: enabled,
          onChanged: onChanged,
          thumbColor: .resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return theme.colorScheme.onPrimary;
            }
            return outline;
          }),
          trackColor: .resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return theme.colorScheme.primary;
            }
            return theme.colorScheme.surface;
          }),
          trackOutlineColor: .resolveWith((states) {
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
