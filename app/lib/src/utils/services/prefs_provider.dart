import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'prefs_provider.g.dart';

@Riverpod(keepAlive: true, name: 'asyncPreferences')
SharedPreferencesAsync asyncPrefs(Ref ref) {
  return SharedPreferencesAsync();
}

@Riverpod(keepAlive: true, name: 'securePreferences')
FlutterSecureStorage securePrefs(Ref ref) {
  return const FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
  );
}
