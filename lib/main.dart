import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

import './screens/auth_screen.dart';
import './screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Yoyo Chatt App',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        accentColor: Colors.greenAccent,
        fontFamily: 'Montserrat',
        textTheme: ThemeData.light().textTheme.copyWith(
              headline6: TextStyle(
                fontFamily: 'Quicksand',
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              button: TextStyle(
                color: Colors.white,
              ),
              bodyText1: TextStyle(
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.w500,
              ),
              bodyText2: TextStyle(
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.w400,
              ),
            ),
        buttonTheme: ButtonTheme.of(context).copyWith(
          buttonColor: Colors.deepPurple,
          textTheme: ButtonTextTheme.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ),
        ),
        appBarTheme: AppBarTheme(
          textTheme: ThemeData.light().textTheme.copyWith(
                headline6: TextStyle(
                  fontFamily: 'Quicksand',
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
        ),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: StreamBuilder<User>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (ctx, user) {
          if (user.hasData) {
            return HomeScreen();
          }
          return AuthScreen();
        },
      ),
      // routes: {
      //   '/': (ctx) => AuthScreen(),
      //   AuthScreen.routeName: (ctx) => AuthScreen(),
      //   HomeScreen.routeName: (ctx) => HomeScreen(),
      // },
    );
  }
}
