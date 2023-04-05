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
    this.username,
  }) : super(key: key);

  final String message;
  final MessageType type;
  final bool isMe;
  final String time;
  final String peerAvatar;
  final String username;

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
                                Theme.of(context).colorScheme.secondary,
                              ),
                            ),
                          ),
                        ),
                      )
                    : Container(
                        width: 35.0,
                        child: CircleAvatar(
                          radius: 15.0,
                          child: FittedBox(
                            child: Text(
                              widget.username.characters.first,
                            ),
                          ),
                        ),
                      )
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
                                      .textTheme
                                      .titleLarge
                                      .color,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                : widget.type == MessageType.IMAGE
                    ? Container(
                        margin: EdgeInsets.only(left: 10.0, bottom: 6.0),
                        child: TextButton(
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.zero,
                          ),
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
                                    Theme.of(context).colorScheme.secondary,
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
                                  title: 'From ${widget.username}',
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
                    color: Theme.of(context).textTheme.titleLarge.color,
                  ),
                ),
              )
            : Container(),
      ],
    );
  }
}
