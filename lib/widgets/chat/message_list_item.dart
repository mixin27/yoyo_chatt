import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import './theme/message_bubble.dart';
import '../../utils/message_type.dart';

class MessageItem extends StatelessWidget {
  MessageItem({Key key, this.message}) : super(key: key);

  final QueryDocumentSnapshot message;
  final me = FirebaseAuth.instance.currentUser.uid;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: MessageBubble(
        key: ValueKey(message.id),
        message: message['content'],
        type: message['type'] == 0
            ? MessageType.TEXT
            : message['type'] == 1
                ? MessageType.IMAGE
                : MessageType.STICKER,
        isMe: message['idFrom'] == me,
        time: message['timestamp'],
        peerAvatar: message['idFrom'] == me
            ? message['toAvatar']
            : message['fromAvatar'],
        username: message['idFrom'] == me
            ? message['toUsername']
            : message['fromUsername'],
      ),
    );
  }
}
