import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pocketa/src/features/account/account.dart';
import 'package:pocketa/src/features/auth/auth.dart';
import 'package:pocketa/src/widgets/widgets.dart';

part 'routes.g.dart';

/// For routes rendered in full screen mode (outside of shell)
final rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');

/// For routes rendered within the shell (with bottom navigation bar)
final shellNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'shell');

@TypedShellRoute<LayoutShell>(
  routes: [
    TypedGoRoute<HomeRoute>(path: '/'),
    TypedGoRoute<TransactionsRoute>(
      path: '/transactions',
      routes: [
        TypedGoRoute<AddTransactionRoute>(path: 'add'),
        TypedGoRoute<GetTransactionRoute>(path: ':id'),
      ],
    ),
    TypedGoRoute<InsightsRoute>(path: '/insights'),
    TypedGoRoute<ProfileRoute>(path: '/profile'),
  ],
)
@immutable
class LayoutShell extends ShellRouteData {
  const LayoutShell();

  static final $navigatorKey = shellNavigatorKey;

  @override
  Widget builder(BuildContext context, GoRouterState state, Widget navigator) =>
      AppLayout(child: navigator);
}

@TypedGoRoute<OnboardingRoute>(path: '/onboarding')
@immutable
class OnboardingRoute extends GoRouteData with $OnboardingRoute {
  const OnboardingRoute();

  static final $parentNavigatorKey = rootNavigatorKey;

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const OnboardScreen();
}

@TypedGoRoute<LoginRoute>(path: '/login')
@immutable
class LoginRoute extends GoRouteData with $LoginRoute {
  const LoginRoute();

  static final $parentNavigatorKey = rootNavigatorKey;

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const LoginScreen();
}

@TypedGoRoute<SignupRoute>(path: '/signup')
@immutable
class SignupRoute extends GoRouteData with $SignupRoute {
  const SignupRoute();

  static final $parentNavigatorKey = rootNavigatorKey;

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const SignupScreen();
}

@immutable
class HomeRoute extends GoRouteData with $HomeRoute {
  const HomeRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) => Container();
}

@immutable
class TransactionsRoute extends GoRouteData with $TransactionsRoute {
  const TransactionsRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) => Container();
}

@immutable
class AddTransactionRoute extends GoRouteData with $AddTransactionRoute {
  const AddTransactionRoute();

  static final $parentNavigatorKey = rootNavigatorKey;

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      Container(color: Colors.white);
}

@immutable
class GetTransactionRoute extends GoRouteData with $GetTransactionRoute {
  const GetTransactionRoute({required this.id});

  final int id;

  @override
  Widget build(BuildContext context, GoRouterState state) => Container();
}

@immutable
class InsightsRoute extends GoRouteData with $InsightsRoute {
  const InsightsRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) => Container();
}

@immutable
class ProfileRoute extends GoRouteData with $ProfileRoute {
  const ProfileRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const ProfileScreen();
}
