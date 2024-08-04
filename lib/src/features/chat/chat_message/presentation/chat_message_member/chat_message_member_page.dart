import 'package:flutter/material.dart';

import 'package:auto_route/auto_route.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:yoyo_chatt/src/features/account/other_users/presentation/widgets/other_user_list_item.dart';
import 'package:yoyo_chatt/src/features/chat/chat_message/presentation/chat_message_member/chat_message_member_controller.dart';
import 'package:yoyo_chatt/src/routes/routes.dart';
import 'package:yoyo_chatt/src/shared/constants.dart';
import 'package:yoyo_chatt/src/shared/extensions/dart_extensions.dart';
import 'package:yoyo_chatt/src/shared/utils/async/async_value_ui.dart';
import 'package:yoyo_chatt/src/shared/utils/utils.dart';

@RoutePage()
class ChatMessageMemberPage extends HookConsumerWidget {
  const ChatMessageMemberPage({
    super.key,
    required this.roomId,
  });

  @PathParam('id')
  final String roomId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(
      chatRoomStreamProvider(roomId),
      (_, state) => state.showAlertDialogOnError(context),
    );

    ref.listen(
      chatRoomAdminStreamProvider(roomId),
      (_, state) => state.showAlertDialogOnError(context),
    );

    final roomState = ref.watch(chatRoomStreamProvider(roomId));
    final rolesState = ref.watch(chatRoomAdminStreamProvider(roomId));

    return Scaffold(
      appBar: AppBar(
        title: Text('Members'.hardcoded),
      ),
      body: roomState.when(
        data: (room) {
          return ChatMemberList(
            users: room.users,
            roles: rolesState.when(
              data: (roles) => roles,
              error: (_, __) => {},
              loading: () => {},
            ),
          );
        },
        error: (_, error) => Center(
          child: Text(error.toString()),
        ),
        loading: () => const Center(
          child: CircularProgressIndicator.adaptive(),
        ),
      ),
    );
  }
}

class ChatMemberList extends StatelessWidget {
  const ChatMemberList({
    super.key,
    required this.users,
    this.roles,
  });

  final List<types.User> users;
  final Map<String, dynamic>? roles;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: users.length,
      itemBuilder: (context, index) {
        final member = users[index];

        return ChatMemberListItem(
          user: member,
          roles: roles,
        );
      },
    );
  }
}

class ChatMemberListItem extends HookConsumerWidget {
  const ChatMemberListItem({
    super.key,
    required this.user,
    this.roles,
  });

  final types.User user;
  final Map<String, dynamic>? roles;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final role = roles?['userRoles'][user.id] as String?;
    final isRoleExist = !role.isNullOrEmpty && (role?.toLowerCase() != 'null');

    return ListTile(
      onTap: () async {
        if (user.id == FirebaseChatCore.instance.firebaseUser?.uid) return;

        final room = await ref
            .read(otherUserListItemClickControllerProvider.notifier)
            .startChat(user);

        if (context.mounted) {
          context.router.pushAndPopUntil(
            ChatMessageRoute(
              roomId: room.id,
              room: room,
            ),
            predicate: (route) => route.settings.name == HomeRoute.name,
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
      trailing: isRoleExist ? Text('$role') : null,
    );
  }
}
