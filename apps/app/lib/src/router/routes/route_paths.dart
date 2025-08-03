class RoutePaths {
  static const String home = '/';
  static const transactions = _TransactionRoutes();
  static const String insights = '/insights';
  static const String user = '/user';
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String register = '/signup';
}

class _TransactionRoutes {
  const _TransactionRoutes();
  final String path = '/transactions';
  final String addSegment = 'add';
  String get add => '$path/$addSegment';
}
