import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';

import '../screens/chat_screen.dart';

class UserListItem extends StatelessWidget {
  UserListItem({
    Key key,
    @required this.userData,
  }) : super(key: key);

  final DocumentSnapshot userData;
  final currentUser = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: userData.data()['id'] == currentUser.uid
          ? Container()
          : Card(
              child: ListTile(
                onTap: () {
                  // Fluttertoast.showToast(msg: userData.data().toString());
                  // navigate to chat screen.
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (ctx) => ChattScreen(
                      peerUser: userData.data(),
                    ),
                  ));
                },
                leading: userData.data()['photoUrl'] == ''
                    ? CircleAvatar(
                        radius: 25.0,
                        child: FittedBox(
                          child: Text(
                            userData
                                .data()['username']
                                .toString()
                                .characters
                                .first,
                          ),
                        ),
                      )
                    : Material(
                        borderRadius: BorderRadius.circular(25.0),
                        clipBehavior: Clip.hardEdge,
                        child: CachedNetworkImage(
                          imageUrl: userData.data()['photoUrl'],
                          placeholder: (ctx, url) => Container(
                            width: 50.0,
                            height: 50.0,
                            padding: EdgeInsets.all(5.0),
                            child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation(
                                  Theme.of(ctx).accentColor),
                            ),
                          ),
                          fit: BoxFit.cover,
                          width: 50.0,
                          height: 50.0,
                        ),
                      ),
                title: Text(
                  userData.data()['username'],
                ),
                subtitle: Text(
                    'Since ${DateFormat.yMMMd().format(DateTime.fromMillisecondsSinceEpoch(int.parse(userData.data()['createdAt'].toString())))}'),
              ),
            ),
    );
  }
}
