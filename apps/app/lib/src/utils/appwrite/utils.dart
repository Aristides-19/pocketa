import 'package:appwrite/appwrite.dart';

List<String> userPermissions(String userId) {
  return [
    Permission.read(Role.user(userId)),
    Permission.update(Role.user(userId)),
  ];
}
