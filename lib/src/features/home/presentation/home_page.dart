import 'package:flutter/material.dart';

import 'package:auto_route/auto_route.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:yoyo_chatt/src/features/home/presentation/home_page_controller.dart';
import 'package:yoyo_chatt/src/routes/routes.dart';
import 'package:yoyo_chatt/src/shared/extensions.dart';
import 'package:yoyo_chatt/src/shared/widgets.dart';

@RoutePage()
class HomePage extends StatefulHookConsumerWidget {
  const HomePage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  @override
  Widget build(BuildContext context) {
    ref.listen(
      homePageControllerProvider,
      (_, state) => state.showAlertDialogOnError(context),
    );

    final state = ref.watch(homePageControllerProvider);

    return Scaffold(
      drawer: Drawer(
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
                // Padding(
                //   padding: const EdgeInsets.symmetric(vertical: Sizes.p12),
                //   child: Align(
                //     alignment: Alignment.center,
                //     child: SizedBox(
                //       height: 80,
                //       child: Image.asset(AssetPaths.logoText),
                //     ),
                //   ),
                // ),
              ],
            )
          ],
        ),
      ),
      appBar: AppBar(
        title: const Text('Chatt'),
        actions: [
          TextButton(
            onPressed: state.isLoading
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
                      await ref
                          .read(homePageControllerProvider.notifier)
                          .logout();

                      if (context.mounted) {
                        context.router.replaceAll([const HomeRoute()]);
                      }
                    }
                  },
            child: Text('Logout'.hardcoded),
          ),
        ],
      ),
    );
  }
}
