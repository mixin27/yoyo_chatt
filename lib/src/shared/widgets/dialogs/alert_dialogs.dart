import 'package:flutter/material.dart';

/// Generic function to show a platform-aware Material or Cupertino error dialog
Future<void> showExceptionAlertDialog({
  required BuildContext context,
  required String title,
  required dynamic exception,
}) =>
    showAdaptiveDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(exception.toString()),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Ok'),
          ),
        ],
      ),
    );
