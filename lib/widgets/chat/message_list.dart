import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import './message_list_item.dart';
import '../../utils/const.dart';

class MessageLists extends StatefulWidget {
  MessageLists({Key key, @required this.chatId, this.listScrollController})
      : super(key: key);
  final String chatId;
  final ScrollController listScrollController;

  @override
  _MessageListsState createState() => _MessageListsState();
}

class _MessageListsState extends State<MessageLists> {
  int _limit = 20;
  List<DocumentSnapshot> listMessage = new List.from([]);

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: widget.chatId == ''
          ? Center()
          : StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection(messagesCollection)
                  .doc(widget.chatId)
                  .collection(widget.chatId)
                  .orderBy('timestamp', descending: true)
                  .limit(_limit)
                  .snapshots(),
              builder: (ctx, snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Theme.of(context).colorScheme.secondary,
                      ),
                    ),
                  );
                } else {
                  listMessage.addAll(snapshot.data.docs);
                  return ListView.builder(
                    itemBuilder: (ctx, i) => MessageItem(
                      message: snapshot.data.docs[i],
                    ),
                    itemCount: snapshot.data.docs.length,
                    reverse: true,
                    controller: widget.listScrollController,
                  );
                }
              },
            ),
    );
  }
}
