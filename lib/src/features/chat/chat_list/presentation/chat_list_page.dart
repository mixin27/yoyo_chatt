import 'package:flutter/material.dart';

import 'package:auto_route/auto_route.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:yoyo_chatt/src/features/chat/chat_list/presentation/chat_list_controller.dart';
import 'package:yoyo_chatt/src/routes/routes.dart';
import 'package:yoyo_chatt/src/shared/constants/app_sizes.dart';
import 'package:yoyo_chatt/src/shared/extensions/dart_extensions.dart';
import 'package:yoyo_chatt/src/shared/widgets.dart';
import 'widgets/chat_list_item.dart';

@RoutePage()
class ChatListPage extends HookConsumerWidget {
  const ChatListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(
      chatListStreamProvider,
      (_, state) => state.showAlertDialogOnError(context),
    );

    final chatRooms = ref.watch(chatListStreamProvider);

    return Scaffold(
      // drawer: const AppDrawer(),
      appBar: AppBar(
        title: const Text('Yo. Chatt'),
      ),
      body: chatRooms.when(
        data: (rooms) {
          if (rooms.isEmpty) {
            return Center(
              child: Text('Start Chat'.hardcoded),
            );
          }

          return ListView.builder(
            itemCount: rooms.length,
            itemBuilder: (context, index) {
              final room = rooms[index];
              return ChatListItem(room: room);
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
      floatingActionButtonLocation: ExpandableFab.location,

      floatingActionButton: ExpandableFab(
        type: ExpandableFabType.up,
        distance: 65,
        openButtonBuilder: RotateFloatingActionButtonBuilder(
          child: const Icon(Icons.menu_open_outlined),
          fabSize: ExpandableFabSize.regular,
          shape: const CircleBorder(),
        ),
        children: [
          Row(
            children: [
              Text('Direct'.hardcoded),
              gapW20,
              FloatingActionButton(
                heroTag: 'direct-add',
                onPressed: () =>
                    context.router.navigate(const OtherUsersRoute()),
                child: const Icon(Icons.person_add_outlined),
              ),
            ],
          ),
          Row(
            children: [
              Text('Group'.hardcoded),
              gapW20,
              FloatingActionButton(
                heroTag: 'group-add',
                onPressed: () =>
                    context.router.push(const CreateGroupChatRoute()),
                child: const Icon(Icons.group_add_outlined),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
