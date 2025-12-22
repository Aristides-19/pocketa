import 'dart:io';

import 'package:device_preview/device_preview.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pocketa/src/app.dart';
import 'package:pocketa/src/constants/constants.dart';
import 'package:pocketa/src/localization/locale.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:toastification/toastification.dart';

void main() async {
  await dotenv.load();
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await Supabase.initialize(
    url: AppEnv.supabaseUrl,
    anonKey: AppEnv.supabaseAnonKey,
    postgrestOptions: const PostgrestClientOptions(schema: 'api'),
  );

  runApp(
    ProviderScope(
      retry: (_, _) => null,
      child: DevicePreview(
        enabled: !kReleaseMode && (kIsWeb || Platform.isWindows),
        builder: (ctx) => EasyLocalization(
          supportedLocales: const [Locale('en'), Locale('es')],
          path: 'assets/langs',
          fallbackLocale: const Locale('en'),
          assetLoader: const CodegenLoader(),
          child: const ToastificationWrapper(child: App()),
        ),
      ),
    ),
  );
}
