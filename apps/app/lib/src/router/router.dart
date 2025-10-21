import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pocketa/src/features/auth/auth.dart';
import 'package:pocketa/src/router/keys.dart';
import 'package:pocketa/src/router/routes/routes.dart';
import 'package:pocketa/src/widgets/widgets.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'router.g.dart';

@Riverpod(keepAlive: true)
GoRouter router(Ref ref) {
  String? redirect(GoRouterState state) {
    final authState = ref.read(authStreamProvider);

    if (authState.isLoading || authState.hasError) return null;

    final isLoggedIn = authState.value?.user != null;
    final isGoingToPublicRoute = [
      RoutePaths.onboarding,
      RoutePaths.login,
      RoutePaths.signup,
    ].contains(state.matchedLocation);

    if (!isLoggedIn && !isGoingToPublicRoute) return RoutePaths.login;
    if (isLoggedIn && isGoingToPublicRoute) return RoutePaths.home;
    return null;
  }

  final router = GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: RoutePaths.onboarding,
    redirect: (BuildContext context, GoRouterState state) => redirect(state),
    routes: [
      GoRoute(
        path: RoutePaths.onboarding,
        parentNavigatorKey: rootNavigatorKey,
        builder: (BuildContext context, GoRouterState state) =>
            const OnboardScreen(),
      ),
      GoRoute(
        path: RoutePaths.login,
        parentNavigatorKey: rootNavigatorKey,
        builder: (BuildContext context, GoRouterState state) =>
            const LoginScreen(),
      ),
      GoRoute(
        path: RoutePaths.signup,
        parentNavigatorKey: rootNavigatorKey,
        builder: (BuildContext context, GoRouterState state) =>
            const SignupScreen(),
      ),
      ShellRoute(
        navigatorKey: shellNavigatorKey,
        builder: (BuildContext context, GoRouterState state, Widget child) {
          return AppLayout(child: child);
        },
        routes: <GoRoute>[
          homeRoute,
          transactionsRoute,
          insightsRoute,
          userRoute,
        ],
      ),
    ],
  );

  ref.listen(authStreamProvider, (_, _) => router.refresh());

  return router;
}
