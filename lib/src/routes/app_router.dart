import 'package:auto_route/auto_route.dart';

import 'package:yoyo_chatt/src/routes/routes.dart';

@AutoRouterConfig()
class AppRouter extends RootStackRouter {
  @override
  List<AutoRoute> get routes => [
        AutoRoute(
          page: HomeRoute.page,
          path: '/',
          guards: [AuthGuard()],
          children: [
            AutoRoute(page: ChatListRoute.page, path: 'chat/list'),
            AutoRoute(page: OtherUsersRoute.page, path: 'account/other-users'),
            AutoRoute(page: ProfileRoute.page, path: 'account/me'),
          ],
        ),

        // Chat
        AutoRoute(
            page: ChatMessageRoute.page,
            guards: [AuthGuard()],
            path: '/chat/message/:id'),
        AutoRoute(
            page: CreateGroupChatRoute.page,
            guards: [AuthGuard()],
            path: '/chat/group/create'),
        AutoRoute(
          page: ChatMessageMemberRoute.page,
          guards: [AuthGuard()],
          path: '/chat/message/:id/members',
        ),

        // Account
        AutoRoute(
            page: EditProfileRoute.page,
            guards: [AuthGuard()],
            path: '/account/me/edit'),
        AutoRoute(page: ProfileImageRoute.page, path: '/account/profile/photo'),
        AutoRoute(
            page: AccountSettingsRoute.page,
            guards: [AuthGuard()],
            path: '/account/settings'),
        AutoRoute(
            page: DeleteAccountRoute.page,
            guards: [AuthGuard()],
            path: '/account/delete'),
        AutoRoute(
            page: AccountEmailRoute.page,
            guards: [AuthGuard()],
            path: '/account/email'),
        AutoRoute(
          page: ChangePasswordRoute.page,
          path: '/account/change-password',
        ),

        // Authentication
        AutoRoute(page: EmailPasswordSignInRoute.page, path: '/auth/login'),

        // Misc
        AutoRoute(page: AboutRoute.page, path: '/app/about'),
        AutoRoute(page: PrivacyPolicyRoute.page, path: '/app/privacy-policy'),
        AutoRoute(page: NotificationRoute.page, path: '/app/notifications'),
      ];
}
