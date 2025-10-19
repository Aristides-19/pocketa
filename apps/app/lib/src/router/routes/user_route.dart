import 'package:go_router/go_router.dart';
import 'package:pocketa/src/features/profile/profile.dart';
import 'package:pocketa/src/router/routes/routes.dart';

final GoRoute userRoute = GoRoute(
  path: RoutePaths.user,
  builder: (context, state) {
    return const ProfileScreen();
  },
);
