import 'package:appwrite/appwrite.dart' show Client;
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pocketa/src/app.dart';
import 'package:pocketa/src/constants/constants.dart';
import 'package:pocketa/src/localization/locale.dart';
import 'package:pocketa/src/utils/appwrite/providers.dart';
import 'package:toastification/toastification.dart';

void main() async {
  await dotenv.load();
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  Client client = Client()
      .setEndpoint(AppEnv.endpoint)
      .setProject(AppEnv.projectId);

  runApp(
    ProviderScope(
      overrides: [appwriteClientProvider.overrideWithValue(client)],
      child: EasyLocalization(
        supportedLocales: const [Locale('en'), Locale('es')],
        path: 'assets/langs',
        fallbackLocale: const Locale('en'),
        assetLoader: const CodegenLoader(),
        child: const ToastificationWrapper(child: App()),
      ),
    ),
  );
}
