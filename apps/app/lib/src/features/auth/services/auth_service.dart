import 'dart:developer';

import 'package:pocketa/src/features/auth/auth.dart';
import 'package:pocketa/src/features/auth/repository/auth_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_service.g.dart';

@Riverpod(keepAlive: true)
class AuthService extends _$AuthService {
  @override
  Future<Auth?> build() {
    log('AuthService initialized', name: 'AuthService');
    return ref.read(authRepositoryProvider).getCurrentUser();
  }
}
