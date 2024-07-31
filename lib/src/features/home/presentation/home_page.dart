import 'package:flutter/material.dart';

import 'package:auto_route/auto_route.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:yoyo_chatt/src/features/account/account.dart';
import 'package:yoyo_chatt/src/features/chat/chat.dart';
import 'package:yoyo_chatt/src/features/home/presentation/home_page_controller.dart';
import 'package:yoyo_chatt/src/features/home/presentation/widgets/home_bottom_nav.dart';
import 'package:yoyo_chatt/src/features/home/presentation/widgets/home_bottom_nav_controller.dart';
import 'package:yoyo_chatt/src/shared/widgets.dart';

@RoutePage()
class HomePage extends StatefulHookConsumerWidget {
  const HomePage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  final List<Widget> pages = const [
    ChatListPage(),
    OtherUsersPage(),
    ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    ref.listen(
      homePageControllerProvider,
      (_, state) => state.showAlertDialogOnError(context),
    );

    final pageIndex = ref.watch(homeBottomNavControllerProvider);

    return Scaffold(
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: pages.elementAt(pageIndex),
      ),
      bottomNavigationBar: const HomeBottomNav(),
    );
  }
}
