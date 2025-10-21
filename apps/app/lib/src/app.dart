import 'package:flutter/material.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pocketa/src/constants/constants.dart';
import 'package:pocketa/src/features/auth/auth.dart';
import 'package:pocketa/src/features/crypto/crypto.dart';
import 'package:pocketa/src/localization/locale.dart';
import 'package:pocketa/src/router/router.dart';
import 'package:pocketa/src/utils/services/toaster_service.dart';

class App extends ConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.read(routerProvider);

    ref
      ..listen(authStreamProvider, (_, curr) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (curr.isLoading) return;
          final toast = ref.read(toastProvider);

          final e = curr.error;
          if (e is Exception) {
            toast.showException(e);
            return;
          }

          if (curr.value?.reason == AuthChangeReason.login ||
              curr.value?.reason == AuthChangeReason.restore) {
            toast.add(
              ToasterMode.success,
              LocaleKeys.auth_login_success_title.tr(),
              LocaleKeys.auth_login_success_message.tr(),
            );
          } else if (curr.value?.reason == AuthChangeReason.signup) {
            toast.add(
              ToasterMode.success,
              LocaleKeys.auth_signup_success_title.tr(),
              LocaleKeys.auth_signup_success_message.tr(),
            );
          } else if (curr.value?.reason == AuthChangeReason.logout) {
            toast.add(
              ToasterMode.info,
              LocaleKeys.auth_logout_success_title.tr(),
              LocaleKeys.auth_logout_success_message.tr(),
            );
          } else if (curr.value?.reason == AuthChangeReason.expired) {
            toast.add(
              ToasterMode.warning,
              LocaleKeys.auth_session_expired_title.tr(),
              LocaleKeys.auth_session_expired_message.tr(),
            );
          }
        });
      })
      ..listen(authMutationProvider, (_, curr) {
        if (curr.isLoading) return;
        final e = curr.error;
        if (e is Exception) {
          ref.read(toastProvider).showException(e);
        }
      })
      ..listen(authStreamProvider, (_, curr) async {
        if (curr.isLoading) return;

        final crypto = ref.read(cryptoProvider);
        final val = curr.unwrapPrevious().value;

        if (val != null && val.reason == AuthChangeReason.restore) {
          try {
            await crypto.init();
          } on PasswordRequiredException catch (e) {
            await ref.read(authMutationProvider.notifier).logout();
            ref
                .read(toastProvider)
                .showException(e, duration: 10, dismissAll: true);
          }
        } else if (val?.user == null ||
            val?.reason == AuthChangeReason.logout) {
          await crypto.logout();
        }
      });

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      localizationsDelegates: [
        FormBuilderLocalizations.delegate,
        ...context.localizationDelegates,
      ],
      supportedLocales: context.supportedLocales,
      locale: context.locale,

      title: AppInfo.appName,
      theme: AppTheme.light,
      themeMode: ThemeMode.system,

      routerConfig: router,
    );
  }
}
