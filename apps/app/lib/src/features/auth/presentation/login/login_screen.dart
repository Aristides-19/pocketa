import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:go_router/go_router.dart';
import 'package:pocketa/src/features/auth/presentation/validators.dart';
import 'package:pocketa/src/localization/locale_keys.g.dart';
import 'package:pocketa/src/router/routes/routes.dart';
import 'package:pocketa/src/widgets/widgets.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final formKey = GlobalKey<FormBuilderState>();

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
            onPressed: () {
              if (formKey.currentState?.validate() ?? false) {}
            },
            width: double.infinity,
          ),
          const SizedBox(height: 35),

          Center(
            child: LabelButton(
              label: LocaleKeys.auth_no_account.tr(),
              onPressed: () => context.go(RoutePaths.signup),
            ),
          ),
        ],
      ),
    );
  }
}
