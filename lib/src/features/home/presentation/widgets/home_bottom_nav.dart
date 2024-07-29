import 'package:flutter/material.dart';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:iconly/iconly.dart';

import 'package:yoyo_chatt/src/features/home/presentation/widgets/home_bottom_nav_controller.dart';
import 'package:yoyo_chatt/src/shared/utils/extensions/dart_extensions.dart';

class HomeBottomNav extends HookConsumerWidget {
  const HomeBottomNav({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final index = ref.watch(homeBottomNavControllerProvider);

    return NavigationBar(
      animationDuration: const Duration(milliseconds: 400),
      selectedIndex: index,
      labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
      onDestinationSelected: (index) => ref
          .read(homeBottomNavControllerProvider.notifier)
          .setAndPersistValue(index),
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
  }
}
