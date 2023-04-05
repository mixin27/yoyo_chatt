import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../screens/settings_screen.dart';
import '../widgets/user_list_item.dart';
import '../utils/const.dart';

class HomeScreen extends StatelessWidget {
  void handleSignout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getBool(prefsIsGoogleSignIn)) {
      final googleSignIn = GoogleSignIn();
      googleSignIn.disconnect();
      googleSignIn.signOut();
    }

    prefs.clear();
    await FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Yoyo Chatt'),
        actions: [
          PopupMenuButton(
            itemBuilder: (ctx) => [
              PopupMenuItem(
                child: Row(
                  children: [
                    Icon(
                      Icons.settings,
                      color: Theme.of(context).iconTheme.color,
                    ),
                    SizedBox(width: 8),
                    Text('Settings'),
                  ],
                ),
                value: 'settings',
              ),
              PopupMenuItem(
                child: Row(
                  children: [
                    Icon(
                      Icons.exit_to_app,
                      color: Theme.of(context).iconTheme.color,
                    ),
                    SizedBox(width: 8),
                    Text('Log out'),
                  ],
                ),
                value: 'logout',
              ),
            ],
            onSelected: (item) {
              if (item == 'logout') {
                handleSignout();
              }
              if (item == 'settings') {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (ctx) => SettingsScreen(),
                  ),
                );
              }
            },
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream:
            FirebaseFirestore.instance.collection(usersCollection).snapshots(),
        builder: (ctx, snapshot) {
          if (!snapshot.hasData) {
            return Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Text(
                    'No chatt users found!',
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 24,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 16.0),
                  Icon(
                    Icons.hourglass_empty,
                    size: 70,
                    color: Colors.grey,
                  ),
                ],
              ),
            );
          } else {
            return ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemBuilder: (ctx, index) => UserListItem(
                userData: snapshot.data.docs[index]
                    as DocumentSnapshot<Map<String, dynamic>>,
              ),
              itemCount: snapshot.data.docs.length,
            );
          }
        },
      ),
    );
  }
}
