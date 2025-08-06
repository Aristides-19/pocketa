import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pocketa/src/features/auth/presentation/controller.dart';
import 'package:pocketa/src/features/auth/presentation/validators.dart';
import 'package:pocketa/src/localization/locale_keys.g.dart';
import 'package:pocketa/src/router/routes/routes.dart';
import 'package:pocketa/src/widgets/widgets.dart';

class LoginScreen extends HookConsumerWidget {
  const LoginScreen({super.key});

  void handleLogin(WidgetRef ref, GlobalKey<FormBuilderState> formKey) {
    final form = formKey.currentState;
    if (form == null) return;

    final isValid = form.validate();
    if (!isValid) return;

    final email = form.fields['email']?.value as String;
    final password = form.fields['password']?.value as String;
    ref.read(authControllerProvider.notifier).logIn(email, password);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textTheme = TextTheme.of(context);
    final formKey = useRef(GlobalKey<FormBuilderState>()).value;
    final asyncAuth = ref.watch(authControllerProvider);

    return Scaffold(
      body: AppForm(
        formKey: formKey,
        children: [
          const Logo(),
          const SizedBox(height: 20),

          Text(LocaleKeys.auth_login.tr(), style: textTheme.displayMedium),
          const SizedBox(height: 50),

          FormInput(
            name: 'email',
            label: LocaleKeys.auth_email.tr(),
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            autofillHints: const [AutofillHints.email],
            validator: emailValidator(),
          ),
          const SizedBox(height: 25),

          FormInput(
            name: 'password',
            label: LocaleKeys.auth_password.tr(),
            keyboardType: TextInputType.visiblePassword,
            textInputAction: TextInputAction.done,
            autofillHints: const [AutofillHints.password],
            isPassword: true,
            maxLength: 30,
            validator: loginPasswordValidator(),
          ),
          const SizedBox(height: 50),

          Button(
            label: LocaleKeys.auth_login.tr(),
            isLoading: asyncAuth.isLoading,
            onPressed: () => handleLogin(ref, formKey),
            width: double.infinity,
          ),
          const SizedBox(height: 35),

          Center(
            child: LabelButton(
              isLoading: asyncAuth.isLoading,
              label: LocaleKeys.auth_no_account.tr(),
              onPressed: () => context.go(RoutePaths.signup),
            ),
          ),
        ],
      ),
    );
  }
}
