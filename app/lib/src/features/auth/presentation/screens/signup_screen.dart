import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pocketa/src/features/auth/auth.dart';
import 'package:pocketa/src/features/auth/presentation/validators.dart';
import 'package:pocketa/src/localization/locale.dart';
import 'package:pocketa/src/router/routes/routes.dart';
import 'package:pocketa/src/widgets/widgets.dart';

class SignupScreen extends HookConsumerWidget {
  const SignupScreen({super.key});

  void handleSignup(WidgetRef ref, GlobalKey<FormBuilderState> formKey) {
    final form = formKey.currentState;
    if (form == null) return;

    final isValid = form.validate();
    if (!isValid) return;

    final username = form.fields['username']?.value as String;
    final email = form.fields['email']?.value as String;
    final password = form.fields['password']?.value as String;
    ref.read(authMutation.notifier).signUp(username, email, password);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formKey = useRef(GlobalKey<FormBuilderState>()).value;
    final textTheme = TextTheme.of(context);
    final authMutate = ref.watch(authMutation);

    return Scaffold(
      body: AppForm(
        formKey: formKey,
        children: [
          const Logo(),
          const SizedBox(height: 20),

          /// Signup Title
          Text(LocaleKeys.auth_signup.tr(), style: textTheme.displayMedium),
          const SizedBox(height: 50),

          /// Email Field
          FormInput(
            name: 'email',
            label: LocaleKeys.auth_email.tr(),
            keyboardType: .emailAddress,
            textInputAction: .next,
            autofillHints: const [AutofillHints.email],
            validator: emailValidator(),
          ),
          const SizedBox(height: 25),

          /// Username Field
          FormInput(
            name: 'username',
            label: LocaleKeys.auth_username.tr(),
            keyboardType: .text,
            textInputAction: .next,
            autofillHints: const [AutofillHints.nickname],
            validator: usernameValidator(),
            maxLength: 20,
          ),
          const SizedBox(height: 25),

          /// Password Field
          FormInput(
            name: 'password',
            label: LocaleKeys.auth_password.tr(),
            keyboardType: .visiblePassword,
            textInputAction: .next,
            autofillHints: const [AutofillHints.password],
            obscure: true,
            maxLength: 30,
            validator: signupPasswordValidator(),
          ),
          const SizedBox(height: 25),

          /// Confirm Password Field
          FormInput(
            name: 'confirm_password',
            label: LocaleKeys.auth_confirm_password.tr(),
            keyboardType: .visiblePassword,
            textInputAction: .done,
            autofillHints: const [AutofillHints.password],
            obscure: true,
            maxLength: 30,
            validator: confirmPasswordValidator(formKey),
          ),
          const SizedBox(height: 50),

          /// Signup Button
          Button(
            label: LocaleKeys.auth_signup.tr(),
            loading: authMutate.isLoading,
            onPressed: () => handleSignup(ref, formKey),
            width: double.infinity,
          ),
          const SizedBox(height: 35),

          /// Have Account Label Button
          Center(
            child: LabelButton(
              disabled: authMutate.isLoading,
              label: LocaleKeys.auth_have_account.tr(),
              onPressed: () => context.go(RoutePaths.login),
            ),
          ),
        ],
      ),
    );
  }
}
