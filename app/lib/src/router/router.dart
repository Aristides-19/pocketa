import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pocketa/src/features/auth/auth.dart';
import 'package:pocketa/src/router/routes.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'router.g.dart';

@Riverpod(keepAlive: true, name: r'$router')
GoRouter router(Ref ref) {
  String? redirect(GoRouterState state) {
    final authState = ref.read($authStreamQuery);

    if (authState.isLoading || authState.hasError) return null;

    final isLoggedIn = authState.value?.user != null;
    final isGoingToPublicRoute = [
      const OnboardingRoute().location,
      const LoginRoute().location,
      const SignupRoute().location,
    ].contains(state.matchedLocation);

    if (!isLoggedIn && !isGoingToPublicRoute) {
      return const LoginRoute().location;
    }
    if (isLoggedIn && isGoingToPublicRoute) {
      return const HomeRoute().location;
    }
    return null;
  }

  final router = GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: const OnboardingRoute().location,
    redirect: (BuildContext context, GoRouterState state) => redirect(state),
    routes: $appRoutes,
  );

  ref.listen($authStreamQuery, (_, _) => router.refresh());

  return router;
}
