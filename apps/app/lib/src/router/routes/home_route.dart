import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pocketa/src/router/routes/routes.dart';

final GoRoute homeRoute = GoRoute(
  path: RoutePaths.home,
  builder: (context, state) {
    return Container();
  },
);
