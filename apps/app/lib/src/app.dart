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
      ..listen(authProvider, (_, curr) {
        if (curr.isLoading || curr.hasError) return;

        final toast = ref.read(toastProvider);
        if (curr.value?.reason == AuthChangeReason.login ||
            curr.value?.reason == AuthChangeReason.sessionRestore) {
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
        }
      })
      ..listen(authProvider, (_, curr) async {
        final crypto = ref.read(cryptoProvider);
        final val = curr.unwrapPrevious().value;
        if (val != null && val.reason == AuthChangeReason.sessionRestore) {
          await crypto.init();
        } else if (val == null) {
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
