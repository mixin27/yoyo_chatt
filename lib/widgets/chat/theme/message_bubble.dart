import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../../screens/full_photo_screen.dart';
import '../../../utils/message_type.dart';

class MessageBubble extends StatefulWidget {
  MessageBubble({
    Key key,
    this.message,
    this.type,
    this.isMe,
    this.time,
    this.peerAvatar,
  }) : super(key: key);

  final String message;
  final MessageType type;
  final bool isMe;
  final String time;
  final String peerAvatar;

  @override
  _MessageBubbleState createState() => _MessageBubbleState();
}

class _MessageBubbleState extends State<MessageBubble> {
  bool _isShowTime = false;

  void onBubbleTap() {
    setState(() {
      _isShowTime = !_isShowTime;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment:
              widget.isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
          children: [
            !widget.isMe
                ? widget.peerAvatar != ''
                    ? Material(
                        borderRadius: BorderRadius.all(Radius.circular(18.0)),
                        clipBehavior: Clip.hardEdge,
                        child: CachedNetworkImage(
                          imageUrl: widget.peerAvatar,
                          width: 35.0,
                          height: 35.0,
                          fit: BoxFit.cover,
                          placeholder: (ctx, url) => Container(
                            width: 35.0,
                            height: 35.0,
                            padding: EdgeInsets.all(10.0),
                            child: CircularProgressIndicator(
                              strokeWidth: 1.0,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                  Theme.of(context).accentColor),
                            ),
                          ),
                        ),
                      )
                    : Container(width: 35.0)
                : Container(),
            widget.type == MessageType.TEXT
                ? GestureDetector(
                    onTap: onBubbleTap,
                    child: Container(
                      decoration: BoxDecoration(
                        color: widget.isMe
                            ? Theme.of(context).primaryColor
                            : Colors.grey[300],
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(18),
                          topRight: Radius.circular(18),
                          bottomLeft: widget.isMe
                              ? Radius.circular(18)
                              : Radius.circular(0),
                          bottomRight: widget.isMe
                              ? Radius.circular(0)
                              : Radius.circular(18),
                        ),
                      ),
                      // width: 200.0,
                      constraints: BoxConstraints(maxWidth: 200),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14.0, vertical: 10.0),
                      margin: const EdgeInsets.symmetric(
                          vertical: 5.0, horizontal: 8.0),
                      child: Column(
                        crossAxisAlignment: widget.isMe
                            ? CrossAxisAlignment.end
                            : CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.message,
                            style: TextStyle(
                              fontFamily: 'Montserrat',
                              fontSize: 16,
                              color: widget.isMe
                                  ? Colors.white
                                  : Theme.of(context)
                                      .accentTextTheme
                                      .headline6
                                      .color,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                : widget.type == MessageType.IMAGE
                    ? Container(
                        margin: EdgeInsets.only(left: 10.0),
                        child: FlatButton(
                          padding: EdgeInsets.all(0),
                          child: Material(
                            borderRadius: BorderRadius.all(
                              Radius.circular(8.0),
                            ),
                            clipBehavior: Clip.hardEdge,
                            child: CachedNetworkImage(
                              width: 200.0,
                              height: 200.0,
                              fit: BoxFit.cover,
                              imageUrl: widget.message,
                              placeholder: (ctx, url) => Container(
                                width: 200.0,
                                height: 200.0,
                                padding: EdgeInsets.all(70.0),
                                decoration: BoxDecoration(
                                  color: Colors.grey[300],
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(8.0),
                                  ),
                                ),
                                child: CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Theme.of(context).accentColor,
                                  ),
                                ),
                              ),
                              errorWidget: (context, url, error) => Material(
                                child: Image.asset(
                                  'images/img_not_available.jpeg',
                                  width: 200.0,
                                  height: 200.0,
                                  fit: BoxFit.cover,
                                ),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(8.0),
                                ),
                                clipBehavior: Clip.hardEdge,
                              ),
                            ),
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => FullPhotoScreen(
                                  photoUrl: widget.message,
                                ),
                              ),
                            );
                          },
                        ),
                      )
                    : Container(
                        margin: widget.isMe
                            ? const EdgeInsets.only(bottom: 5.0, right: 5.0)
                            : const EdgeInsets.only(bottom: 5.0, left: 5.0),
                        child: Image.asset(
                          'images/${widget.message}.gif',
                          width: 100.0,
                          height: 100.0,
                          fit: BoxFit.cover,
                        ),
                      ),
          ],
        ),
        _isShowTime
            ? Container(
                margin: const EdgeInsets.only(bottom: 5.0),
                child: Text(
                  '${DateFormat('dd MMM, hh:mm a').format(DateTime.fromMillisecondsSinceEpoch(int.parse(widget.time)))}',
                  style: TextStyle(
                    fontSize: 12,
                    color: Theme.of(context).accentTextTheme.headline6.color,
                  ),
                ),
              )
            : Container(),
      ],
    );
  }
}
