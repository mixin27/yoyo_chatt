import 'package:flutter/material.dart';

import 'package:auto_route/auto_route.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:yoyo_chatt/src/routes/app_router.gr.dart';

@RoutePage()
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FilledButton(
              onPressed: () async {
                await FirebaseAuth.instance.signOut();

                if (context.mounted) {
                  context.router.replaceAll([const HomeRoute()]);
                }
              },
              child: const Text('Logout'),
            ),
            FilledButton(
              onPressed: () {
                context.router.push(const UsersRoute());
              },
              child: const Text('Go To Users Page'),
            ),
          ],
        ),
      ),
    );
  }
}
