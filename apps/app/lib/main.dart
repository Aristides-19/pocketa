import 'package:appwrite/appwrite.dart' as appwrite;
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pocketa/src/app.dart';
import 'package:pocketa/src/localization/locale.dart';
import 'package:pocketa/src/utils/appwrite/providers.dart';

void main() async {
  await dotenv.load();
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  appwrite.Client client = appwrite.Client()
      .setEndpoint(dotenv.env['APPWRITE_ENDPOINT']!)
      .setProject(dotenv.env['APPWRITE_PROJECT_ID']!);

  runApp(
    ProviderScope(
      overrides: [appwriteClientProvider.overrideWithValue(client)],
      child: EasyLocalization(
        supportedLocales: const [Locale('en'), Locale('es')],
        path: 'assets/langs',
        fallbackLocale: const Locale('en'),
        assetLoader: const CodegenLoader(),
        child: const App(),
      ),
    ),
  );
}
