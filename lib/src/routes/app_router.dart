import 'package:auto_route/auto_route.dart';

import 'package:yoyo_chatt/src/routes/guards/auth_guard.dart';
import 'app_router.gr.dart';

@AutoRouterConfig()
class AppRouter extends $AppRouter {
  @override
  List<AutoRoute> get routes => [
        AutoRoute(page: HomeRoute.page, path: '/', guards: [AuthGuard()]),

        // auth
        AutoRoute(page: EmailPasswordSignInRoute.page, path: '/auth'),

        // users
        AutoRoute(
          page: UsersRoute.page,
          path: '/users',
          guards: [AuthGuard()],
        ),
      ];
}
