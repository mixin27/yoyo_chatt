import 'package:flutter/material.dart';

import 'package:auto_route/auto_route.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:yoyo_chatt/src/features/account/account.dart';
import 'package:yoyo_chatt/src/features/chat/chat.dart';
import 'package:yoyo_chatt/src/features/home/presentation/widgets/home_bottom_nav.dart';
import 'package:yoyo_chatt/src/features/home/presentation/widgets/home_bottom_nav_controller.dart';

@RoutePage()
class HomePage extends StatefulHookConsumerWidget {
  const HomePage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage>
    with WidgetsBindingObserver {
  final List<Widget> pages = const [
    ChatListPage(),
    OtherUsersPage(),
    ProfilePage(),
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.resumed) {
      // change online
    } else {
      // change offline
      // ref.read(homePageControllerProvider.notifier).setLastSeen();

      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return;

      final usersCollectionRef = FirebaseFirestore.instance.collection('users');
      await usersCollectionRef.doc(user.uid).update({
        'lastSeen': FieldValue.serverTimestamp(),
      });
    }
    super.didChangeAppLifecycleState(state);
  }

  @override
  Widget build(BuildContext context) {
    // ref.listen(
    //   homePageControllerProvider,
    //   (_, state) => state.showAlertDialogOnError(context),
    // );

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
