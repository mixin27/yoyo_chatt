import 'package:flutter/material.dart';

import 'package:auto_route/auto_route.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:yoyo_chatt/src/features/account/other_users/presentation/other_users_controller.dart';
import 'package:yoyo_chatt/src/shared/extensions/dart_extensions.dart';
import 'package:yoyo_chatt/src/shared/utils/async/async_value_ui.dart';
import 'widgets/other_user_list_item.dart';

@RoutePage()
class OtherUsersPage extends HookConsumerWidget {
  const OtherUsersPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(
      otherUsersStreamProvider,
      (_, state) => state.showAlertDialogOnError(context),
    );

    final otherUsers = ref.watch(otherUsersStreamProvider);

    return Scaffold(
      // drawer: const AppDrawer(),
      appBar: AppBar(
        title: const Text('Other Users'),
      ),
      body: otherUsers.when(
        data: (users) {
          if (users.isEmpty) {
            return Center(
              child: Text('No users found.'.hardcoded),
            );
          }

          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              final user = users[index];
              return OtherUserListItem(user: user);
            },
          );
        },
        error: (error, _) => Center(
          child: Text(error.toString()),
        ),
        loading: () => const Center(
          child: CircularProgressIndicator.adaptive(),
        ),
      ),
    );
  }
}
