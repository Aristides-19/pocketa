import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pocketa/src/constants/constants.dart';
import 'package:pocketa/src/features/auth/auth.dart';
import 'package:pocketa/src/localization/locale.dart';
import 'package:pocketa/src/router/routes/route_paths.dart';
import 'package:pocketa/src/utils/services/toaster_service.dart';
import 'package:pocketa/src/widgets/widgets.dart';

class OnboardScreen extends ConsumerWidget {
  const OnboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    ref.listen(authServiceProvider, (_, current) {
      if (current.value != null) {
        ref
            .read(toasterServiceProvider)
            .add(
              ToasterMode.success,
              LocaleKeys.auth_login_success_title.tr(),
              LocaleKeys.auth_login_success_message.tr(),
            );
      }
    });

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Stack(
            children: [
              Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Logo(width: 150),
                    const SizedBox(height: 27),
                    Text.rich(
                      TextSpan(
                        style: textTheme.displayLarge,
                        children: <TextSpan>[
                          TextSpan(text: LocaleKeys.onboarding_welcome.tr()),
                          TextSpan(
                            text: AppInfo.appName,
                            style: TextStyle(color: theme.colorScheme.primary),
                          ),
                        ],
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    Text(
                      LocaleKeys.onboarding_description.tr(),
                      style: textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),

              Align(
                alignment: const Alignment(0.0, 0.7),
                child: Button(
                  label: LocaleKeys.onboarding_get_started.tr(),
                  onPressed: () => context.go(RoutePaths.login),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
