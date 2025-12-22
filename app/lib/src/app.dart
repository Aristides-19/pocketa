import 'package:flutter/material.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pocketa/src/constants/constants.dart';
import 'package:pocketa/src/features/auth/auth.dart';
import 'package:pocketa/src/features/crypto/crypto.dart';
import 'package:pocketa/src/localization/locale.dart';
import 'package:pocketa/src/router/router.dart';
import 'package:pocketa/src/utils/services/toaster_provider.dart';

class App extends ConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.read(routerProvider);

    ref
      ..listen($authStream, (_, curr) {
        // TODO - Handle exceptions
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (curr.isLoading) return;
          final toast = ref.read($toastService);

          final e = curr.error;
          if (e is Exception) {
            toast.showException(e);
            return;
          }

          switch (curr.value?.reason) {
            case AuthChangeReason.login:
            case AuthChangeReason.restore:
              toast.add(
                ToasterMode.success,
                LocaleKeys.auth_login_success_title.tr(),
                LocaleKeys.auth_login_success_message.tr(),
              );
              break;
            case AuthChangeReason.signup:
              toast.add(
                ToasterMode.success,
                LocaleKeys.auth_signup_success_title.tr(),
                LocaleKeys.auth_signup_success_message.tr(),
              );
              break;
            case AuthChangeReason.logout:
              toast.add(
                ToasterMode.info,
                LocaleKeys.auth_logout_success_title.tr(),
                LocaleKeys.auth_logout_success_message.tr(),
              );
              break;
            case AuthChangeReason.expired:
              toast.add(
                ToasterMode.warning,
                LocaleKeys.auth_session_expired_title.tr(),
                LocaleKeys.auth_session_expired_message.tr(),
              );
              break;
            case AuthChangeReason.refresh:
            case null:
              break;
          }
        });
      })
      ..listen(authMutation, (_, curr) {
        if (curr.isLoading) return;
        final e = curr.error;
        if (e is Exception) ref.read($toastService).showException(e);
      })
      ..listen($cryptoService, (_, curr) {
        if (curr.isLoading) return;

        final e = curr.error;
        if (e is Exception) {
          final toast = ref.read($toastService);
          if (e is PasswordRequiredException) {
            toast.showException(e, dismissAll: true, duration: 10);
            return;
          }
          toast.showException(e);
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
