import 'dart:io';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import '../screens/full_photo_screen.dart';
import '../widgets/profile_image.dart';
import '../widgets/user_info_item.dart';
import '../utils/const.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final currentUser = FirebaseAuth.instance.currentUser;
  SharedPreferences prefs;
  bool _isGoogleSignIn = false;
  File _imageFile;
  bool _isLoading = false;
  String uploadImageUrl = '';

  final userNameTextEditingController = TextEditingController();
  final phoneNumberTextEditingController = TextEditingController();

  // void onLogoutTap() {
  //   showDialog(
  //       context: context,
  //       builder: (ctx) => Dismissible(
  //             key: ValueKey(widget.key),
  //             onDismissed: (direction) {
  //               Navigator.of(ctx).pop();
  //             },
  //             child: AlertDialog(
  //               title: Text('Logout'),
  //               content: Text('Are you sure to want to log out?'),
  //               actions: [
  //                 FlatButton(
  //                   onPressed: handleSignout,
  //                   child: Text('OK'),
  //                 ),
  //               ],
  //             ),
  //           ));
  // }

  void handleSignout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (_isGoogleSignIn) {
      final googleSignIn = GoogleSignIn();
      googleSignIn.disconnect();
      googleSignIn.signOut();
    }

    prefs.clear();
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).pop();
  }

  void readLocal() async {
    prefs = await SharedPreferences.getInstance();
    _isGoogleSignIn = prefs.getBool(prefsIsGoogleSignIn);

    // force refresh ui
    setState(() {});
  }

  void handleProfileImageTap(String url) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) =>
            FullPhotoScreen(title: 'Profile Image', photoUrl: url),
      ),
    );
  }

  Future<void> getImage() async {
    final imagePicker = ImagePicker();
    final pickedFile = await imagePicker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 50,
    );

    if (pickedFile == null) {
      return;
    }

    final imageFile = File(pickedFile.path);
    if (imageFile == null) {
      return;
    }

    setState(() {
      _imageFile = imageFile;
      _isLoading = true;
    });
    print('Picked Image Path: $_imageFile.path');

    uploadImageFile();
  }

  Future<void> uploadImageFile() async {
    final fileName = currentUser.uid;
    try {
      final uploadTask = await FirebaseStorage.instance
          .ref('$usersImagePath/$fileName')
          .putFile(_imageFile);
      uploadTask.ref.getDownloadURL().then((url) {
        uploadImageUrl = url;
        print('ImageUploadTo: $uploadImageUrl');

        FirebaseFirestore.instance
            .collection(usersCollection)
            .doc(currentUser.uid)
            .update({
          'photoUrl': uploadImageUrl,
        }).then((data) {
          setState(() {
            _isLoading = false;
          });
          Fluttertoast.showToast(msg: 'Photo upload success!');
        });
      }).catchError((err) {
        setState(() {
          _isLoading = false;
        });
        Fluttertoast.showToast(msg: err.toString());
      });
    } on FirebaseException catch (err) {
      Fluttertoast.showToast(msg: err.message);
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    readLocal();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Settings',
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding:
                  const EdgeInsets.only(left: 10.0, top: 10.0, right: 10.0),
              child: Card(
                // elevation: 4,
                child: Container(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'Personal Information',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      Divider(),
                      SizedBox(height: 10.0),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                            stream: FirebaseFirestore.instance
                                .collection(usersCollection)
                                .doc(currentUser.uid)
                                .snapshots(),
                            builder: (ctx, snapshot) {
                              if (snapshot.hasData) {
                                if (snapshot.data.data()['photoUrl'] == '')
                                  return CircleAvatar(
                                    radius: 50.0,
                                    child: Text(
                                      snapshot.data
                                          .data()['username']
                                          .toString()
                                          .characters
                                          .first,
                                      style: TextStyle(fontSize: 50),
                                    ),
                                  );
                                return ProfileImage(
                                  imgUrl: snapshot.data.data()['photoUrl'],
                                  handleImageTap: handleProfileImageTap,
                                );
                              } else {
                                return CircleAvatar(
                                  radius: 50.0,
                                  child: Icon(
                                    Icons.broken_image,
                                    size: 50,
                                  ),
                                );
                              }
                            },
                          ),
                          SizedBox(height: 10.0),
                          _isLoading
                              ? CircularProgressIndicator()
                              : TextButton.icon(
                                  onPressed: getImage,
                                  icon: Icon(
                                    Icons.photo,
                                    // color: Theme.of(context).primaryColor,
                                  ),
                                  label: Text(
                                    'Edit Photo',
                                  ),
                                ),
                          Divider(),
                          StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                              stream: FirebaseFirestore.instance
                                  .collection(usersCollection)
                                  .doc(currentUser.uid)
                                  .snapshots(),
                              builder: (ctx, snapshot) {
                                if (snapshot.hasData) {
                                  return Column(
                                    children: [
                                      UserInfoItem(
                                        icon: Icons.account_circle,
                                        info: snapshot.data.data()['username'],
                                        field: 'username',
                                        handleEdit: () {},
                                      ),
                                      UserInfoItem(
                                        icon: Icons.phone,
                                        info: snapshot.data
                                                .data()['phoneNumber'] ??
                                            '',
                                        field: 'phoneNumber',
                                        handleEdit: () {},
                                      ),
                                      UserInfoItem(
                                        icon: Icons.info,
                                        info: snapshot.data.data()['aboutMe'] ??
                                            'About Me',
                                        field: 'aboutMe',
                                        handleEdit: () {},
                                      ),
                                      UserInfoItem(
                                        icon: Icons.email,
                                        info: snapshot.data.data()['email'],
                                        field: 'email',
                                        handleEdit: null,
                                      ),
                                      UserInfoItem(
                                        icon: Icons.timeline,
                                        info:
                                            'Join on ${DateFormat.yMMMd().format(DateTime.fromMillisecondsSinceEpoch(int.parse(snapshot.data.data()['createdAt'].toString())))}',
                                        field: 'createdAt',
                                        handleEdit: null,
                                      ),
                                    ],
                                  );
                                } else {
                                  return Container();
                                }
                              }),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Container(
              padding:
                  const EdgeInsets.only(left: 10.0, top: 10.0, right: 10.0),
              // child: Card(
              // elevation: 4,
              child: Container(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Additional Settings',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    Divider(),
                    ListTile(
                      title: Text('Account login type'),
                      trailing: _isGoogleSignIn
                          ? Text(
                              'Google',
                              style: TextStyle(
                                color: Colors.red,
                              ),
                            )
                          : Text(
                              'Email/Password',
                              style: TextStyle(
                                color: Theme.of(context).primaryColorDark,
                              ),
                            ),
                    ),
                    ListTile(
                      title: Text('Terms & conditions'),
                      onTap: () {
                        Fluttertoast.showToast(
                            msg: 'Navigate to Terms & conditions page.');
                      },
                    ),
                    ListTile(
                      title: Text('Privacy and policies'),
                      onTap: () {
                        Fluttertoast.showToast(
                            msg: 'Navigate to Privacy and policy page.');
                      },
                    ),
                    Divider(),
                    ListTile(
                      title: Text(
                        'Log out',
                        style: TextStyle(color: Colors.red),
                      ),
                      onTap: handleSignout,
                    ),
                  ],
                ),
              ),
            ),
            // ),
          ],
        ),
      ),
    );
  }
}
