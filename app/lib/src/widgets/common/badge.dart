import 'package:flutter/material.dart';
import 'package:pocketa/src/constants/theme.dart';

class CommonBadge extends StatelessWidget {
  const CommonBadge({
    super.key,
    required this.content,
    this.variant = BadgeVariant.primary,
  });

  final String content;
  final BadgeVariant variant;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: variant.backgroundColor(colors),
        borderRadius: AppTheme.borderRadius - const .all(.circular(10)),
        border: variant.border(colors),
      ),
      child: Text(
        content,
        style: theme.textTheme.labelSmall?.copyWith(
          color: variant.foregroundColor(colors),
          fontWeight: .bold,
        ),
      ),
    );
  }
}

enum BadgeVariant {
  primary,
  secondary,
  tertiary,
  surface,
  error;

  Color backgroundColor(ColorScheme colors) => switch (this) {
    BadgeVariant.primary => colors.primaryContainer,
    BadgeVariant.secondary => colors.secondaryContainer,
    BadgeVariant.tertiary => colors.tertiaryContainer,
    BadgeVariant.surface => colors.surfaceContainer,
    BadgeVariant.error => colors.errorContainer,
  };

  Color foregroundColor(ColorScheme colors) => switch (this) {
    BadgeVariant.primary => colors.onPrimaryContainer,
    BadgeVariant.secondary => colors.onSecondaryContainer,
    BadgeVariant.tertiary => colors.onTertiaryContainer,
    BadgeVariant.surface => colors.onSurface,
    BadgeVariant.error => colors.onErrorContainer,
  };

  BoxBorder? border(ColorScheme colors) => switch (this) {
    _ => null,
  };
}
