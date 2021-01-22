import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../widgets/auth/auth_form.dart';
import '../utils/utils.dart';
import '../utils/const.dart';

class AuthScreen extends StatefulWidget {
  static const routeName = '/auth';

  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _auth = FirebaseAuth.instance;
  var _isLoading = false;

  void _submitAuthForm(
    String email,
    String username,
    String password,
    bool isLogin,
    BuildContext ctx,
  ) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    UserCredential userCredential;
    try {
      setState(() {
        _isLoading = true;
      });

      if (isLogin) {
        userCredential = await _auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );

        prefs.setBool(prefsIsGoogleSignIn, false);
      } else {
        userCredential = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
        await FirebaseFirestore.instance
            .collection(usersCollection)
            .doc(userCredential.user.uid)
            .set({
          'id': userCredential.user.uid,
          'username': username,
          'email': email,
          'photoUrl': '',
          'phoneNumber': '',
          'createdAt': DateTime.now().millisecondsSinceEpoch.toString(),
          'chattingWith': null,
        });

        prefs.setBool(prefsIsGoogleSignIn, false);
      }
    } on PlatformException catch (err) {
      var message = 'An error occurred, please check your credentials!';
      if (err.message != null) {
        message = err.message;
      }
      Utils.showErrorMessage(ctx, message);
      setState(() {
        _isLoading = false;
      });
    } catch (err) {
      print(err);
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _handleGoogleSignIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _isLoading = true;
    });

    try {
      final googleSignIn = GoogleSignIn();
      final googleUser = await googleSignIn.signIn();
      final googleAuth = await googleUser.authentication;
      final googleCredential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final firebaseUser =
          (await _auth.signInWithCredential(googleCredential)).user;

      if (firebaseUser != null) {
        // Check this already sign up
        final result = await FirebaseFirestore.instance
            .collection(usersCollection)
            .where('id', isEqualTo: firebaseUser.uid)
            .get();
        final List<DocumentSnapshot> documents = result.docs;
        if (documents.length == 0) {
          // Update data to server if new user
          FirebaseFirestore.instance
              .collection(usersCollection)
              .doc(firebaseUser.uid)
              .set({
            'id': firebaseUser.uid,
            'username': firebaseUser.displayName,
            'email': firebaseUser.email,
            'photoUrl': firebaseUser.photoURL,
            'phoneNumber': firebaseUser.phoneNumber,
            'createdAt': DateTime.now().millisecondsSinceEpoch.toString(),
            'chattingWith': null,
          });
        }

        prefs.setBool(prefsIsGoogleSignIn, true);

        Fluttertoast.showToast(msg: 'Sign In Success.');

        // if sign in successful, navigate to home page.
        // Navigator.of(context).pushReplacementNamed(HomeScreen.routeName);
      } else {
        Fluttertoast.showToast(msg: 'Sign In Failed.');
        setState(() {
          _isLoading = false;
        });
      }
    } catch (err) {
      print(err);
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: AuthForm(
        submitForm: _submitAuthForm,
        handleSignInWithGoogle: _handleGoogleSignIn,
        isLoading: _isLoading,
      ),
    );
  }
}
