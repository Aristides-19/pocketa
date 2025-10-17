import 'package:appwrite/appwrite.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'providers.g.dart';

@Riverpod(keepAlive: true)
Client appwriteClient(Ref ref) {
  throw UnimplementedError('Override appwriteClientProvider in main');
}

@Riverpod(keepAlive: true)
Account appwriteAccount(Ref ref) {
  final client = ref.watch(appwriteClientProvider);
  return Account(client);
}

@Riverpod(keepAlive: true)
TablesDB appwriteDb(Ref ref) {
  final client = ref.watch(appwriteClientProvider);
  return TablesDB(client);
}
