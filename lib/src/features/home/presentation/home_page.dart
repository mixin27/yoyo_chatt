import 'package:flutter/material.dart';

import 'package:auto_route/auto_route.dart';
import 'package:iconly/iconly.dart';

import 'package:yoyo_chatt/src/routes/routes.dart';
import 'package:yoyo_chatt/src/shared/extensions.dart';
import 'package:yoyo_chatt/src/shared/widgets.dart';

@RoutePage()
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ToggleOnlineWidget(
      child: AutoTabsScaffold(
        routes: const [
          ChatListRoute(),
          OtherUsersRoute(),
          ProfileRoute(),
        ],
        transitionBuilder: (context, child, animation) => FadeTransition(
          opacity: animation,
          child: child,
        ),
        bottomNavigationBuilder: (context, tabsRouter) {
          return NavigationBar(
            animationDuration: const Duration(milliseconds: 400),
            selectedIndex: tabsRouter.activeIndex,
            labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
            onDestinationSelected: (index) => tabsRouter.setActiveIndex(index),
            destinations: [
              NavigationDestination(
                icon: const Icon(IconlyLight.message),
                label: 'Message'.hardcoded,
              ),
              NavigationDestination(
                icon: const Icon(IconlyLight.user),
                label: 'Users'.hardcoded,
              ),
              NavigationDestination(
                icon: const Icon(IconlyLight.profile),
                label: 'Profile'.hardcoded,
              ),
            ],
          );
        },
        // builder: (context, child) {
        //   return Scaffold(
        //     body: child,
        //     bottomNavigationBar: const HomeBottomNav(),
        //   );
        // },
      ),
    );
  }
}
