import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';

import './chat_input.dart';
import './message_list.dart';
import './sticker.dart';
import '../../utils/const.dart';
import '../../utils/message_type.dart';

class PeerChat extends StatefulWidget {
  PeerChat({Key key, @required this.peerUser}) : super(key: key);
  final Map<String, dynamic> peerUser;

  @override
  _PeerChatState createState() => _PeerChatState(other: peerUser);
}

class _PeerChatState extends State<PeerChat> {
  _PeerChatState({@required this.other});

  final Map<String, dynamic> other;
  User me;

  final focusNode = FocusNode();
  final textEditingController = TextEditingController();

  String chatId;
  File imageFile;
  String imageUrl = '';
  bool isShowSticker = false;
  bool isLoading = false;

  void initPeerChat() {
    me = FirebaseAuth.instance.currentUser;

    if (me.uid.hashCode <= other['id'].hashCode) {
      chatId = '${me.uid}-${other['id']}';
    } else {
      chatId = '${other['id']}-${me.uid}';
    }
    FirebaseFirestore.instance
        .collection(usersCollection)
        .doc(me.uid)
        .update({'chattingWith': chatId});

    setState(() {});
  }

  Future<bool> _onBackPressed() {
    FirebaseFirestore.instance
        .collection(usersCollection)
        .doc(me.uid)
        .update({'chattingWith': null});
    Navigator.of(context).pop();
    return Future.value(false);
  }

  Future<void> getImage() async {
    final imagePicker = ImagePicker();
    final PickedFile pickedFile = await imagePicker.getImage(
        source: ImageSource.gallery, imageQuality: 20);
    if (pickedFile == null) {
      return;
    }

    imageFile = File(pickedFile.path);
    if (imageFile != null) {
      setState(() {
        isLoading = true;
      });

      // upload file and get url to send message.
      uploadImageToStorage();
    }
  }

  Future<void> uploadImageToStorage() async {
    final String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    try {
      final uploadTask = await FirebaseStorage.instance
          .ref('$imageMessagePath/$chatId/$fileName')
          .putFile(imageFile);
      uploadTask.ref.getDownloadURL().then((url) {
        imageUrl = url;
        print('ImageUploadTo: $imageUrl');
        setState(() {
          isLoading = false;
          onSendMessage(imageUrl, MessageType.IMAGE);
        });
      }).catchError((err) {
        setState(() {
          isLoading = false;
        });
        Fluttertoast.showToast(msg: err.toString());
      });
    } on FirebaseException catch (err) {
      setState(() {
        isLoading = false;
      });
      Fluttertoast.showToast(msg: err.message);
    }
  }

  void getSticker() {
    // Hide keyboard when sticker appear
    focusNode.unfocus();
    setState(() {
      isShowSticker = !isShowSticker;
    });
  }

  void onSendMessage(
    String content,
    MessageType type,
  ) {
    if (content.trim() != '') {
      textEditingController.clear();

      var docRef = FirebaseFirestore.instance
          .collection(messagesCollection)
          .doc(chatId)
          .collection(chatId)
          .doc(DateTime.now().millisecondsSinceEpoch.toString());

      FirebaseFirestore.instance.runTransaction((transaction) async {
        transaction.set(docRef, {
          'idFrom': me.uid,
          'idTo': other['id'],
          'timestamp': DateTime.now().millisecondsSinceEpoch.toString(),
          'content': content,
          'type': type.index,
        });
      });

      if (isShowSticker) {
        setState(() {
          isShowSticker = !isShowSticker;
        });
      }
    } else {
      // Fluttertoast.showToast(
      //   msg: 'Nothing to send',
      //   backgroundColor: Colors.black,
      //   textColor: Colors.red,
      // );
      print('Noting to send.');
    }
  }

  void onFocusChange() {
    if (focusNode.hasFocus) {
      setState(() {
        // Hide sticker when keyboard appear.
        isShowSticker = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    initPeerChat();
    focusNode.addListener(onFocusChange);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Stack(
        children: [
          Column(
            children: [
              MessageLists(
                chatId: chatId,
              ),
              (isShowSticker)
                  ? Sticker(
                      handleStickerSend: onSendMessage,
                    )
                  : Container(),
              ChatInput(
                handleImagePicked: getImage,
                handleStickerPicked: getSticker,
                handleSendMessage: onSendMessage,
                focusNode: focusNode,
                textEditingController: textEditingController,
              ),
            ],
          ),
        ],
      ),
      onWillPop: _onBackPressed,
    );
  }
}
