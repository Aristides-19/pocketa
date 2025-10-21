import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppEnv {
  static final String supabaseUrl = _get('SUPABASE_URL');
  static final String supabaseAnonKey = _get('SUPABASE_ANON_KEY');

  static String _get(String key) {
    final value = dotenv.env[key];
    assert(value != null && value.isNotEmpty, 'Missing env var: $key');
    return value!;
  }
}
