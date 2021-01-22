import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../utils/const.dart';

class UserInfoItem extends StatefulWidget {
  UserInfoItem(
      {Key key,
      this.icon,
      @required this.info,
      @required this.field,
      this.handleEdit})
      : super(key: key);

  final IconData icon;
  final String info;
  final String field;
  final Function handleEdit;

  @override
  _UserInfoItemState createState() =>
      _UserInfoItemState(field: field, fieldData: info);
}

class _UserInfoItemState extends State<UserInfoItem> {
  _UserInfoItemState({this.field, this.fieldData});

  final _currentUser = FirebaseAuth.instance.currentUser;
  bool isEditMode = false;
  String fieldData;
  String field;
  TextEditingController textEditingController;
  final focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    initFieldData();
  }

  void initFieldData() {
    textEditingController = TextEditingController(text: fieldData);
    setState(() {});
  }

  void updateData() async {
    focusNode.unfocus();

    await FirebaseFirestore.instance
        .collection(usersCollection)
        .doc(_currentUser.uid)
        .update({'$field': fieldData}).then((value) {
      setState(() {
        isEditMode = false;
      });
    }).catchError((err) {
      setState(() {
        isEditMode = false;
      });
      Fluttertoast.showToast(msg: err.toString());
    });

    Fluttertoast.showToast(msg: 'Update Success!');
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        widget.icon,
        color: Theme.of(context).primaryColor,
      ),
      title: isEditMode
          ? TextField(
              decoration: InputDecoration(
                // hintText: 'Your name',
                contentPadding: EdgeInsets.all(5.0),
                // hintStyle: TextStyle(color: Colors.grey),
              ),
              keyboardType: widget.field == 'phoneNumber'
                  ? TextInputType.phone
                  : TextInputType.text,
              controller: textEditingController,
              focusNode: focusNode,
              onChanged: (value) {
                fieldData = value;
              },
            )
          : Text(widget.info),
      trailing: widget.handleEdit == null
          ? null
          : isEditMode
              ? FlatButton(
                  child: Text('Done'),
                  onPressed: updateData,
                )
              : IconButton(
                  icon: Icon(
                    Icons.edit,
                    color: Colors.black,
                  ),
                  onPressed: () {
                    setState(() {
                      isEditMode = true;
                    });
                  },
                ),
    );
  }
}
