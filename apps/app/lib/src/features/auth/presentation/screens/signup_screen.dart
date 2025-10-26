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

          Text(LocaleKeys.auth_signup.tr(), style: textTheme.displayMedium),
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
            name: 'username',
            label: LocaleKeys.auth_username.tr(),
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.next,
            autofillHints: const [AutofillHints.nickname],
            validator: usernameValidator(),
            maxLength: 20,
          ),
          const SizedBox(height: 25),

          FormInput(
            name: 'password',
            label: LocaleKeys.auth_password.tr(),
            keyboardType: TextInputType.visiblePassword,
            textInputAction: TextInputAction.next,
            autofillHints: const [AutofillHints.password],
            obscure: true,
            maxLength: 30,
            validator: signupPasswordValidator(),
          ),
          const SizedBox(height: 25),

          FormInput(
            name: 'confirm_password',
            label: LocaleKeys.auth_confirm_password.tr(),
            keyboardType: TextInputType.visiblePassword,
            textInputAction: TextInputAction.done,
            autofillHints: const [AutofillHints.password],
            obscure: true,
            maxLength: 30,
            validator: confirmPasswordValidator(formKey),
          ),
          const SizedBox(height: 50),

          Button(
            label: LocaleKeys.auth_signup.tr(),
            isLoading: authMutate.isLoading,
            onPressed: () => handleSignup(ref, formKey),
            width: double.infinity,
          ),
          const SizedBox(height: 35),

          Center(
            child: LabelButton(
              isLoading: authMutate.isLoading,
              label: LocaleKeys.auth_have_account.tr(),
              onPressed: () => context.go(RoutePaths.login),
            ),
          ),
        ],
      ),
    );
  }
}
