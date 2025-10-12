import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppEnv {
  static final String projectId = _get('APPWRITE_PROJECT_ID');
  static final String endpoint = _get('APPWRITE_ENDPOINT');
  static final String databaseId = _get('APPWRITE_DATABASE_ID');
  static final String keysCollectionId = _get('APPWRITE_KEYS_COLLECTION_ID');

  static String _get(String key) {
    final value = dotenv.env[key];
    assert(value != null && value.isNotEmpty, 'Missing env var: $key');
    return value!;
  }
}
