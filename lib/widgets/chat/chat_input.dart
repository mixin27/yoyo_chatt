import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';

import '../../utils/message_type.dart';

class ChatInput extends StatefulWidget {
  ChatInput({
    Key key,
    this.handleImagePicked,
    this.handleStickerPicked,
    this.focusNode,
    this.textEditingController,
    this.handleSendMessage,
  }) : super(key: key);
  final Function handleImagePicked;
  final Function handleStickerPicked;
  final Function handleSendMessage;
  final focusNode;
  final textEditingController;

  @override
  _ChatInputState createState() => _ChatInputState();
}

class _ChatInputState extends State<ChatInput> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 50.0,
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: Colors.grey, width: 0.5)),
        color: Colors.white,
      ),
      child: Row(
        children: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 1.0),
            child: IconButton(
              icon: Icon(Icons.camera_alt),
              color: Theme.of(context).primaryColor,
              onPressed: () => widget.handleImagePicked(ImageSource.camera),
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 1.0),
            child: IconButton(
              icon: Icon(Icons.image),
              color: Theme.of(context).primaryColor,
              onPressed: () => widget.handleImagePicked(ImageSource.gallery),
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 1.0),
            child: IconButton(
              icon: Icon(Icons.face),
              onPressed: widget.handleStickerPicked,
              color: Theme.of(context).primaryColor,
            ),
          ),
          Flexible(
            child: Container(
              child: TextField(
                decoration: InputDecoration.collapsed(
                  hintText: 'What would you like to say?',
                  hintStyle: TextStyle(
                    color: Colors.grey,
                  ),
                ),
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontFamily: 'Montserrat',
                  fontSize: 15.0,
                ),
                focusNode: widget.focusNode,
                controller: widget.textEditingController,
                // onSubmitted: (message) =>
                //     widget.handleSendMessage(message, MessageType.TEXT),
              ),
            ),
          ),
          Container(
            child: IconButton(
              icon: Icon(Icons.send),
              color: Theme.of(context).primaryColor,
              onPressed: () {
                widget.handleSendMessage(
                    widget.textEditingController.text, MessageType.TEXT);
              },
            ),
          ),
        ],
      ),
    );
  }
}
