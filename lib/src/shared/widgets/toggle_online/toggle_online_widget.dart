import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ToggleOnlineWidget extends StatefulHookConsumerWidget {
  const ToggleOnlineWidget({super.key, required this.child});

  final Widget child;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ToggleOnlineWidgetState();
}

class _ToggleOnlineWidgetState extends ConsumerState<ToggleOnlineWidget>
    with WidgetsBindingObserver {
  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
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
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
