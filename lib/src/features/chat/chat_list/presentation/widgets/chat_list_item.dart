import 'package:flutter/material.dart';

import 'package:auto_route/auto_route.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:yoyo_chatt/src/routes/routes.dart';
import 'package:yoyo_chatt/src/shared/constants.dart';
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
              radius: 34,
              child: CircleAvatar(
                radius: 30,
                backgroundColor: Colors.grey.shade300,
                child: CachedNetworkImage(
                  imageUrl:
                      '${room.type == types.RoomType.direct ? otherUser.imageUrl : room.imageUrl}',
                  imageBuilder: (context, imageProvider) => Container(
                    margin: const EdgeInsets.all(Sizes.p4),
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: imageProvider,
                        fit: BoxFit.cover,
                      ),
                      shape: BoxShape.circle,
                    ),
                  ),
                  placeholder: (context, url) => const Center(
                    child: CircularProgressIndicator(),
                  ),
                  errorWidget: (context, url, error) => const Center(
                    child: Icon(Icons.broken_image_outlined),
                  ),
                ),
              ),
            )
          : null,
      title: Text(getNameFromUser(otherUser)),
      subtitle: const Text(''),
      trailing: otherUser.lastSeen == null
          ? const SizedBox()
          : Text(getLastSeenTime(otherUser.lastSeen!)),
    );
  }
}
