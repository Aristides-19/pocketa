class RoutePaths {
  static const String home = '/home';
  static const transactions = _TransactionRoutes();
  static const String insights = '/insights';
  static const String user = '/user';
}

class _TransactionRoutes {
  const _TransactionRoutes();
  final String path = '/transactions';
  final String addSegment = 'add';
  String get add => '$path/$addSegment';
}
