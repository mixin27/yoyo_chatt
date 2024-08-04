import 'package:flutter/material.dart';

import 'package:auto_route/auto_route.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:iconly/iconly.dart';

import 'package:yoyo_chatt/src/routes/routes.dart';
import 'package:yoyo_chatt/src/shared/extensions/dart_extensions.dart';

@RoutePage()
class AccountSettingsPage extends HookConsumerWidget {
  const AccountSettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Account'.hardcoded),
      ),
      body: ListView(
        children: [
          ListTile(
            onTap: () => context.router.push(const AccountEmailRoute()),
            leading: const Icon(IconlyLight.message),
            title: Text('Email'.hardcoded),
          ),
          ListTile(
            onTap: () => context.router.push(const ChangePasswordRoute()),
            leading: const Icon(IconlyLight.password),
            title: Text('Change Password'.hardcoded),
          ),
          ListTile(
            onTap: () => context.router.push(
              const DeleteAccountRoute(),
            ),
            leading: const Icon(IconlyLight.delete),
            title: Text('Delete account'.hardcoded),
          ),
        ],
      ),
    );
  }
}
