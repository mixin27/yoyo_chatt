import 'package:flutter/material.dart';

import 'package:auto_route/auto_route.dart';

import 'package:yoyo_chatt/src/features/account/account.dart';
import 'package:yoyo_chatt/src/routes/routes.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          Stack(
            children: [
              UserAccountsDrawerHeader(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                ),
                accountName: const Text(
                  'Username',
                  // style: TextStyle(color: context.colorScheme.onPrimary),
                ),
                accountEmail: const Text(
                  'user@example.com',
                  // style: TextStyle(color: context.colorScheme.onPrimary),
                ),
                onDetailsPressed: () => context.router.push(
                  const HomeRoute(),
                ),
              ),
            ],
          ),
          const LogoutTile(),
        ],
      ),
    );
  }
}
