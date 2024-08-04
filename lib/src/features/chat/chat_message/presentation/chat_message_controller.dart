import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter_chat_types/flutter_chat_types.dart';
import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';
import 'package:http/http.dart' as http;
import 'package:open_filex/open_filex.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'chat_message_controller.g.dart';

@riverpod
class ChatMessageController extends _$ChatMessageController {
  @override
  FutureOr<void> build() {
    // return ;
  }

  void handleMessageTap(
      Message message, String roomId, String documentsDir) async {
    if (message is FileMessage) {
      var localPath = message.uri;

      if (message.uri.startsWith('http')) {
        try {
          final updatedMessage = message.copyWith(isLoading: true);
          FirebaseChatCore.instance.updateMessage(
            updatedMessage,
            roomId,
          );

          final client = http.Client();
          final request = await client.get(Uri.parse(message.uri));
          final bytes = request.bodyBytes;

          localPath = '$documentsDir/${message.name}';

          if (!File(localPath).existsSync()) {
            final file = File(localPath);
            await file.writeAsBytes(bytes);
          }
        } finally {
          final updatedMessage = message.copyWith(isLoading: false);
          FirebaseChatCore.instance.updateMessage(
            updatedMessage,
            roomId,
          );
        }
      }

      await OpenFilex.open(localPath);
    }
  }

  void handlePreviewDataFetched(
    String roomId,
    TextMessage message,
    PreviewData previewData,
  ) {
    final updatedMessage = message.copyWith(previewData: previewData);

    FirebaseChatCore.instance.updateMessage(updatedMessage, roomId);
  }

  Future<void> sendTextMessage(
    String roomId,
    PartialText message,
  ) async {
    FirebaseChatCore.instance.sendMessage(message, roomId);
  }

  Future<void> sendImageMessage(
    String roomId,
    String name,
    int size,
    String uri,
    ui.Image image,
  ) async {
    final message = PartialImage(
      height: image.height.toDouble(),
      name: name,
      size: size,
      uri: uri,
      width: image.width.toDouble(),
    );
    FirebaseChatCore.instance.sendMessage(message, roomId);
  }

  Future<void> sendFileMessage(
    String roomId,
    String name,
    int size,
    String uri,
    String? mimeType,
  ) async {
    final message = PartialFile(
      name: name,
      size: size,
      uri: uri,
      mimeType: mimeType,
    );
    FirebaseChatCore.instance.sendMessage(message, roomId);
  }

  Future<void> deleteChat(String roomId) async {
    await FirebaseChatCore.instance.deleteRoom(roomId);
    // final fu = FirebaseChatCore.instance.firebaseUser;
    // if (fu == null) return;

    // await FirebaseFirestore.instance.collection('room').doc(roomId).update({
    //   'metadata': {
    //     'delete': [
    //       fu.uid,
    //     ],
    //   },
    // });
  }
}

@riverpod
class MessagesStream extends _$MessagesStream {
  Stream<List<Message>> _fetchMessages(Room room) {
    return FirebaseChatCore.instance.messages(room);
  }

  @override
  Stream<List<Message>> build(Room room) {
    return _fetchMessages(room);
  }
}
