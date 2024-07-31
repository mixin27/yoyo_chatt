import 'package:flutter/material.dart';

import 'package:auto_route/auto_route.dart';

import 'package:yoyo_chatt/src/features/app/app.dart';

@RoutePage()
class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AppDrawer(),
      appBar: AppBar(
        title: const Text('Profile'),
      ),
    );
  }
}
