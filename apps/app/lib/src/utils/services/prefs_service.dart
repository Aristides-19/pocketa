import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'prefs_service.g.dart';

@Riverpod(keepAlive: true)
SharedPreferencesAsync prefs(Ref ref) {
  return SharedPreferencesAsync();
}

FlutterSecureStorage securePrefs(Ref ref) {
  return const FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
  );
}
