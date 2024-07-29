import 'dart:developer';

import 'package:flutter/material.dart';

import 'package:auto_route/auto_route.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:yoyo_chatt/src/routes/routes.dart';
import 'package:yoyo_chatt/src/shared/utils/async/async_value_ui.dart';

part 'other_user_list_item.g.dart';

class OtherUserListItem extends HookConsumerWidget {
  const OtherUserListItem({
    super.key,
    required this.user,
  });

  final types.User user;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(
      otherUserListItemClickControllerProvider,
      (_, state) => state.showAlertDialogOnError(context),
    );

    return ListTile(
      onTap: () async {
        final room = await ref
            .read(otherUserListItemClickControllerProvider.notifier)
            .startChat(user);
        log('RoomId: ${room.id}');

        if (context.mounted) {
          context.router.push(
            ChatMessageRoute(
              roomId: room.id,
              room: room,
            ),
          );
        }
      },
      leading: user.imageUrl != null
          ? CircleAvatar(
              backgroundColor: Colors.grey.shade300,
              child: Container(
                width: 50,
                height: 50,
                margin: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(20)),
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: NetworkImage(
                      user.imageUrl ?? '',
                      // scale: 0.5,
                    ),
                  ),
                ),
              ),
            )
          : null,
      title: Text('${user.firstName} ${user.lastName}'),
    );
  }
}

@riverpod
class OtherUserListItemClickController
    extends _$OtherUserListItemClickController {
  @override
  FutureOr<void> build() {
    // return;
  }

  Future<types.Room> startChat(types.User otherUser) async {
    final room = await FirebaseChatCore.instance.createRoom(otherUser);
    return room;
  }
}
