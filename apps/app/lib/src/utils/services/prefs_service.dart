import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'prefs_service.g.dart';

@Riverpod(keepAlive: true)
SharedPreferencesAsync preferencesService(Ref ref) {
  return SharedPreferencesAsync();
}
