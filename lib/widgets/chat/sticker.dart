import 'package:flutter/material.dart';

import './sticker_button.dart';

class Sticker extends StatelessWidget {
  Sticker({
    Key key,
    @required this.handleStickerSend,
  }) : super(key: key);
  final Function handleStickerSend;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: Colors.grey, width: 0.5)),
        color: Colors.white,
      ),
      padding: EdgeInsets.all(5.0),
      height: 180.0,
      child: ListView(
        children: [
          Container(
            padding: const EdgeInsets.only(left: 10.0, top: 10.0, bottom: 10.0),
            child: Text(
              'Sticker Pack Name',
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  StickerButton(
                      stickerName: 'mimi1',
                      handleStickerSend: handleStickerSend),
                  StickerButton(
                      stickerName: 'mimi2',
                      handleStickerSend: handleStickerSend),
                  StickerButton(
                      stickerName: 'mimi3',
                      handleStickerSend: handleStickerSend),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  StickerButton(
                      stickerName: 'mimi4',
                      handleStickerSend: handleStickerSend),
                  StickerButton(
                      stickerName: 'mimi5',
                      handleStickerSend: handleStickerSend),
                  StickerButton(
                      stickerName: 'mimi6',
                      handleStickerSend: handleStickerSend),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  StickerButton(
                      stickerName: 'mimi7',
                      handleStickerSend: handleStickerSend),
                  StickerButton(
                      stickerName: 'mimi8',
                      handleStickerSend: handleStickerSend),
                  StickerButton(
                      stickerName: 'mimi9',
                      handleStickerSend: handleStickerSend),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
