import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

import '../../utils/message_type.dart';

class StickerButton extends StatelessWidget {
  StickerButton({
    Key key,
    @required this.stickerName,
    @required this.handleStickerSend,
  }) : super(key: key);
  final String stickerName;
  final Function handleStickerSend;

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      onPressed: () => handleStickerSend(
        stickerName,
        MessageType.STICKER,
      ),
      child: Image.asset(
        'images/$stickerName.gif',
        width: 50.0,
        height: 50.0,
        fit: BoxFit.cover,
      ),
    );
  }
}
