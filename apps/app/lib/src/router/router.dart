import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pocketa/src/features/auth/auth.dart';
import 'package:pocketa/src/router/routes/routes.dart';
import 'package:pocketa/src/widgets/widgets.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'router.g.dart';

@Riverpod(keepAlive: true)
GoRouter router(Ref ref) {
  String? redirect(GoRouterState state) {
    final authState = ref.read(authServiceProvider);

    if (authState.isLoading || authState.hasError) return null;

    final isLoggedIn = authState.valueOrNull != null;
    final isGoingToPublicRoute = [
      RoutePaths.onboarding,
      RoutePaths.login,
      RoutePaths.signup,
    ].contains(state.matchedLocation);

    if (!isLoggedIn && !isGoingToPublicRoute) return RoutePaths.onboarding;
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

  ref.listen(authServiceProvider, (_, _) => router.refresh());

  return router;
}

final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>(
  debugLabel: 'root',
);
final GlobalKey<NavigatorState> shellNavigatorKey = GlobalKey<NavigatorState>(
  debugLabel: 'shell',
);
