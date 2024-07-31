import 'dart:io';

import 'package:flutter/material.dart';

import 'package:auto_route/auto_route.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';
import 'package:path_provider/path_provider.dart';

import 'package:yoyo_chatt/src/features/chat/chat_message/presentation/chat_message_controller.dart';
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
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) => SafeArea(
        child: SizedBox(
          height: 144,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  handleImageSelection();
                },
                child: const Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: Text('Photo'),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  handleFileSelection();
                },
                child: const Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: Text('File'),
                ),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: Text('Cancel'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
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
        title: Text(getNameFromUser(otherUser)),
      ),
      body: Chat(
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
