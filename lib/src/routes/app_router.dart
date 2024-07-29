import 'package:auto_route/auto_route.dart';

import 'package:yoyo_chatt/src/routes/routes.dart';

@AutoRouterConfig()
class AppRouter extends $AppRouter {
  @override
  List<AutoRoute> get routes => [
        AutoRoute(page: HomeRoute.page, path: '/', guards: [AuthGuard()]),

        // Chat
        AutoRoute(page: ChatListRoute.page, path: '/chat/list'),

        // Account
        AutoRoute(page: OtherUsersRoute.page, path: '/account/other-users'),
        AutoRoute(page: ProfileRoute.page, path: '/account/me'),

        // Authentication
        AutoRoute(page: EmailPasswordSignInRoute.page, path: '/auth/login'),
      ];
}
