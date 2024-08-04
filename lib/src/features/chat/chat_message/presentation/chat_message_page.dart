import 'dart:io';

import 'package:flutter/material.dart';

import 'package:auto_route/auto_route.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:iconly/iconly.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';
import 'package:path_provider/path_provider.dart';

import 'package:yoyo_chatt/src/features/chat/chat_message/presentation/chat_message_controller.dart';
import 'package:yoyo_chatt/src/routes/routes.dart';
import 'package:yoyo_chatt/src/shared/constants/app_sizes.dart';
import 'package:yoyo_chatt/src/shared/extensions/dart_extensions.dart';
import 'package:yoyo_chatt/src/shared/utils/async/async_value_ui.dart';
import 'package:yoyo_chatt/src/shared/utils/utils.dart';

@RoutePage()
class ChatMessagePage extends StatefulHookConsumerWidget {
  const ChatMessagePage({
    super.key,
    required this.roomId,
    required this.room,
  });

  @PathParam('id')
  final String roomId;

  final types.Room room;

  @override
  ConsumerState<ChatMessagePage> createState() => _ChatMessagePageState();
}

class _ChatMessagePageState extends ConsumerState<ChatMessagePage> {
  bool _isAttachmentUploading = false;

  void handleFileSelection() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.any,
    );

    if (result != null && result.files.single.path != null) {
      _setAttachmentUploading(true);

      _setAttachmentUploading(true);
      final name = result.files.single.name;
      final filePath = result.files.single.path!;
      final file = File(filePath);

      try {
        final reference = FirebaseStorage.instance.ref(name);
        await reference.putFile(file);
        final uri = await reference.getDownloadURL();

        ref.read(chatMessageControllerProvider.notifier).sendFileMessage(
              widget.roomId,
              name,
              result.files.single.size,
              uri,
              lookupMimeType(filePath),
            );

        _setAttachmentUploading(false);
      } finally {
        _setAttachmentUploading(false);
      }
    }
  }

  void handleImageSelection() async {
    final result = await ImagePicker().pickImage(
      imageQuality: 70,
      maxWidth: 1440,
      source: ImageSource.gallery,
    );

    if (result != null) {
      _setAttachmentUploading(true);

      final file = File(result.path);
      final size = file.lengthSync();
      final bytes = await result.readAsBytes();
      final image = await decodeImageFromList(bytes);
      final name = result.name;

      try {
        final reference = FirebaseStorage.instance.ref(name);
        await reference.putFile(file);
        final uri = await reference.getDownloadURL();

        ref
            .read(chatMessageControllerProvider.notifier)
            .sendImageMessage(widget.roomId, name, size, uri, image);

        _setAttachmentUploading(false);
      } finally {
        _setAttachmentUploading(false);
      }
    }
  }

  void handleAttachmentPressed() {
    showModalBottomSheet(
        backgroundColor: Colors.transparent,
        barrierLabel: 'attachment-modal',
        context: context,
        builder: (context) {
          return DraggableScrollableSheet(
            builder: (context, scrollController) {
              return Container(
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  color: Theme.of(context).canvasColor,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(25),
                    topRight: Radius.circular(25),
                  ),
                ),
                child: CustomScrollView(
                  controller: scrollController,
                  slivers: [
                    SliverToBoxAdapter(
                      child: Center(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Theme.of(context).hintColor,
                            borderRadius:
                                const BorderRadius.all(Radius.circular(10)),
                          ),
                          height: 4,
                          width: 40,
                          margin: const EdgeInsets.symmetric(vertical: 10),
                        ),
                      ),
                    ),
                    const SliverAppBar(
                      title: Text('Attachments'),
                      primary: false,
                      pinned: true,
                      centerTitle: false,
                    ),
                    SliverList.list(
                      children: [
                        ListTile(
                          onTap: () {
                            Navigator.pop(context);
                            handleImageSelection();
                          },
                          leading: const Icon(IconlyLight.image),
                          title: Text('Photo'.hardcoded),
                        ),
                        ListTile(
                          onTap: () {
                            Navigator.pop(context);
                            handleFileSelection();
                          },
                          leading: const Icon(IconlyLight.folder),
                          title: Text('File'.hardcoded),
                        ),
                      ],
                    )
                  ],
                ),
              );
            },
          );
        });
  }

  void handleSendPressed(types.PartialText message) {
    ref
        .read(chatMessageControllerProvider.notifier)
        .sendTextMessage(widget.roomId, message);
  }

  void _setAttachmentUploading(bool uploading) {
    setState(() {
      _isAttachmentUploading = uploading;
    });
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(
      messagesStreamProvider(widget.room),
      (_, state) => state.showAlertDialogOnError(context),
    );

    final otherUser = getOtherUserFromRoom(widget.room.users);
    final user = getUserFromRoom(widget.room.users);

    final messagesState = ref.watch(messagesStreamProvider(widget.room));

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            InkWell(
              onTap: () => context.router.push(
                ProfileImageRoute(
                  imageUrl:
                      '${widget.room.type == types.RoomType.direct ? otherUser.imageUrl : widget.room.imageUrl}',
                ),
              ),
              child: CircleAvatar(
                radius: 24,
                child: CircleAvatar(
                  radius: 20,
                  backgroundColor: Colors.grey.shade300,
                  child: CachedNetworkImage(
                    imageUrl:
                        '${widget.room.type == types.RoomType.direct ? otherUser.imageUrl : widget.room.imageUrl}',
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
              ),
            ),
            gapW8,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${widget.room.type == types.RoomType.direct ? getNameFromUser(otherUser) : widget.room.name}',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  if (widget.room.type == types.RoomType.direct) ...[
                    Text(
                      getLastSeenTime(otherUser.lastSeen ?? 0),
                      style: Theme.of(context).textTheme.labelSmall,
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
        actions: [
          PopupMenuButton(
            tooltip: 'Menu'.hardcoded,
            itemBuilder: (context) {
              return [
                if (widget.room.type == types.RoomType.group) ...[
                  PopupMenuItem(
                    onTap: () => context.router.push(
                      ChatMessageMemberRoute(roomId: widget.roomId),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.people_outline),
                        gapW4,
                        Expanded(child: Text('Members'.hardcoded)),
                      ],
                    ),
                  ),
                ],
                PopupMenuItem(
                  onTap: () {
                    showAdaptiveDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Text('Delete conversation'.hardcoded),
                            content: const Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                    'Deleting chat is a permanent option. Are you sure you want to delete?')
                              ],
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => context.router.popForced(),
                                child: Text('Cancel'.hardcoded),
                              ),
                              TextButton(
                                onPressed: () {
                                  if (widget.room.type ==
                                      types.RoomType.direct) {
                                    ref
                                        .read(chatMessageControllerProvider
                                            .notifier)
                                        .deleteChat(widget.roomId);

                                    context.router.popUntil((route) =>
                                        route.settings.name == HomeRoute.name);
                                  } else {
                                    // only for admin to delete chat
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          'Currently, deleting a group chat is not supported.'
                                              .hardcoded,
                                        ),
                                      ),
                                    );
                                    context.router.popForced();
                                  }
                                },
                                child: Text('Delete'.hardcoded),
                              ),
                            ],
                          );
                        });
                  },
                  child: Row(
                    children: [
                      const Icon(IconlyLight.delete),
                      gapW4,
                      Expanded(child: Text('Delete'.hardcoded)),
                    ],
                  ),
                ),
              ];
            },
          ),
        ],
      ),
      body: Chat(
        theme: DefaultChatTheme(
          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
          inputBackgroundColor: Theme.of(context).colorScheme.primary,
          attachmentButtonIcon: Icon(
            Icons.folder_outlined,
            color: Theme.of(context).colorScheme.onPrimary,
          ),
        ),
        isAttachmentUploading: _isAttachmentUploading,
        showUserAvatars: true,
        messages: messagesState.when(
          data: (messages) => messages,
          error: (_, __) => [],
          loading: () => [],
        ),
        onSendPressed: handleSendPressed,
        onAttachmentPressed: handleAttachmentPressed,
        onMessageTap: (context, message) async {
          final documentsDir = (await getApplicationCacheDirectory()).path;
          ref
              .read(chatMessageControllerProvider.notifier)
              .handleMessageTap(message, widget.roomId, documentsDir);
        },
        onPreviewDataFetched: (textMessage, previewData) => ref
            .read(chatMessageControllerProvider.notifier)
            .handlePreviewDataFetched(widget.roomId, textMessage, previewData),
        user: user,
      ),
    );
  }
}
