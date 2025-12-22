import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pocketa/src/localization/locale.dart';
import 'package:pocketa/src/widgets/widgets.dart';

class ErrorScreen extends HookWidget {
  /// For displaying an error screen with a retry button.
  /// This should be used for screens that may fail to load essential data to show content.
  const ErrorScreen({super.key, this.onRetry, this.title, this.message});

  final String? title;
  final String? message;
  final Future<void> Function()? onRetry;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final systemPadding = MediaQuery.of(context).padding;
    final isLoading = useState(false);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(
          48.0,
        ).add(.only(bottom: systemPadding.bottom)),
        child: Column(
          mainAxisAlignment: .center,
          children: [
            /// Error Icon
            FaIcon(
              FontAwesomeIcons.circleExclamation,
              size: 74,
              color: theme.colorScheme.error,
            ),
            const SizedBox(height: 28),

            /// Error Title
            Text(
              title ?? LocaleKeys.errors_screen_title.tr(),
              style: theme.textTheme.headlineMedium,
              textAlign: .center,
            ),

            /// Error Message
            const SizedBox(height: 8),
            Text(
              message ?? LocaleKeys.errors_screen_message.tr(),
              style: theme.textTheme.bodyLarge,
              textAlign: .center,
            ),
            const SizedBox(height: 28),

            /// Retry Button
            POutlinedButton(
              label: LocaleKeys.actions_retry.tr(),
              onPressed: () async {
                isLoading.value = true;
                try {
                  await onRetry?.call();
                } finally {
                  isLoading.value = false;
                }
              },
              loading: isLoading.value,
              fontSize: 18,
              height: 54,
            ),
          ],
        ),
      ),
    );
  }
}
