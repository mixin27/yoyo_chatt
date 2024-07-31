import 'package:flutter/material.dart';

import 'package:auto_route/auto_route.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:yoyo_chatt/src/routes/routes.dart';
import 'package:yoyo_chatt/src/shared/utils/utils.dart';

class ChatListItem extends HookConsumerWidget {
  const ChatListItem({super.key, required this.room});

  final types.Room room;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final types.User otherUser = getOtherUserFromRoom(room.users);

    return ListTile(
      onTap: () {
        context.router.push(
          ChatMessageRoute(
            roomId: room.id,
            room: room,
          ),
        );
      },
      leading: otherUser.imageUrl != null
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
                      otherUser.imageUrl ?? '',
                      // scale: 0.5,
                    ),
                  ),
                ),
              ),
            )
          : null,
      title: Text(getNameFromUser(otherUser)),
    );
  }
}
