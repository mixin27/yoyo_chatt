import 'package:auto_route/auto_route.dart';

import 'package:yoyo_chatt/src/routes/routes.dart';

@AutoRouterConfig()
class AppRouter extends $AppRouter {
  @override
  List<AutoRoute> get routes => [
        // AutoRoute(page: HomeRoute.page, path: '/', guards: [AuthGuard()]),
        AutoRoute(page: EmailPasswordSignInRoute.page, path: '/'),
      ];
}
