import 'package:flutter/material.dart';

import 'package:auto_route/auto_route.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:yoyo_chatt/src/features/users/presentation/users_page_controller.dart';
import 'package:yoyo_chatt/src/shared/utils/async/async_value_ui.dart';

@RoutePage()
class UsersPage extends HookConsumerWidget {
  const UsersPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(
      usersListStreamProvider,
      (_, state) => state.showAlertDialogOnError(context),
    );

    final usersState = ref.watch(usersListStreamProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Users'),
      ),
      body: usersState.when(
        data: (users) {
          if (users.isEmpty) return const SizedBox();

          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              final user = users[index];
              return ListTile(
                leading: user.imageUrl != null
                    ? CircleAvatar(
                        child: Image.network(
                          user.imageUrl!,
                          width: 100,
                          height: 100,
                        ),
                      )
                    : null,
                title: Text('${user.firstName} ${user.lastName}'),
              );
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
