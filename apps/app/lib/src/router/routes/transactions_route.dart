import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pocketa/src/router/keys.dart';
import 'package:pocketa/src/router/routes/routes.dart';

final GoRoute transactionsRoute = GoRoute(
  path: RoutePaths.transactions.path,
  builder: (context, state) {
    return Container();
  },
  routes: [
    GoRoute(
      parentNavigatorKey: rootNavigatorKey,
      path: RoutePaths.transactions.addSegment,
      builder: (context, state) {
        return Container();
      },
    ),
  ],
);
