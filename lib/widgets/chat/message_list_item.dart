import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MessageItem extends StatelessWidget {
  MessageItem({Key key, this.index, this.message}) : super(key: key);

  final int index;
  final QueryDocumentSnapshot message;
  final String itemTheme = 'default';
  final me = FirebaseAuth.instance.currentUser.uid;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: message['idFrom'] == me
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(message['content']),
              ],
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(message['content']),
              ],
            ),
    );
  }
}
