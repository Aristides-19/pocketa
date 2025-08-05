import 'package:appwrite/appwrite.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'providers.g.dart';

@Riverpod(keepAlive: true)
Client appwriteClient(Ref ref) {
  throw UnimplementedError('Override appwriteClientProvider in start');
}

@Riverpod(keepAlive: true)
Account appwriteAccount(Ref ref) {
  final client = ref.watch(appwriteClientProvider);
  return Account(client);
}

@Riverpod(keepAlive: true)
Databases appwriteDatabases(Ref ref) {
  final client = ref.watch(appwriteClientProvider);
  return Databases(client);
}
