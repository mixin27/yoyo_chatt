import 'dart:developer';

import 'package:flutter/material.dart';

import 'package:auto_route/auto_route.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:yoyo_chatt/src/routes/routes.dart';
import 'package:yoyo_chatt/src/shared/constants/app_sizes.dart';
import 'package:yoyo_chatt/src/shared/utils/async/async_value_ui.dart';
import 'package:yoyo_chatt/src/shared/utils/utils.dart';

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
              radius: 34,
              child: CircleAvatar(
                radius: 30,
                backgroundColor: Colors.grey.shade300,
                child: CachedNetworkImage(
                  imageUrl: user.imageUrl ?? '',
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
      title: Text('${user.firstName} ${user.lastName}'),
      subtitle: Text(getLastSeenTime(user.lastSeen ?? 0)),
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
