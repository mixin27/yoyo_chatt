import 'package:flutter/material.dart';

class Utils {
  static void showErrorMessage(BuildContext context, String message) {
    Scaffold.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Theme.of(context).errorColor,
      ),
    );
  }
}
