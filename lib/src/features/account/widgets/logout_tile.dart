import 'package:flutter/material.dart';

import 'package:auto_route/auto_route.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:iconly/iconly.dart';

import 'package:yoyo_chatt/src/features/account/widgets/logout_tile_controller.dart';
import 'package:yoyo_chatt/src/routes/routes.dart';
import 'package:yoyo_chatt/src/shared/extensions.dart';

class LogoutTile extends HookConsumerWidget {
  const LogoutTile({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(logoutTileControllerProvider);

    return ListTile(
      onTap: state.isLoading
          ? null
          : () async {
              final confirmed = await showAdaptiveDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text('Logout'.hardcoded),
                  content: Text(
                    'Are you sure you want to logout?'.hardcoded,
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(false),
                      child: Text('Cancel'.hardcoded),
                    ),
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(true),
                      child: Text('Logout'.hardcoded),
                    ),
                  ],
                ),
              );

              if (confirmed == true) {
                await ref.read(logoutTileControllerProvider.notifier).logout();

                if (context.mounted) {
                  context.router.replaceAll([const HomeRoute()]);
                }
              }
            },
      leading: const Icon(
        IconlyLight.logout,
        color: Colors.red,
      ),
      title: Text(
        'Logout'.hardcoded,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(fontSize: 16),
      ),
    );
  }
}
