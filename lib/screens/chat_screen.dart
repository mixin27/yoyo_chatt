import 'package:flutter/material.dart';

import '../widgets/chat/peer_chat.dart';

class ChattScreen extends StatelessWidget {
  ChattScreen({Key key, @required this.peerUser}) : super(key: key);
  final Map<String, dynamic> peerUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${peerUser['username']}'),
      ),
      body: PeerChat(
        peerUser: peerUser,
      ),
    );
  }
}
