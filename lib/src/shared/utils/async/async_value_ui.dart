import 'package:flutter/material.dart';

import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:yoyo_chatt/src/shared/utils/extensions/exceptions.dart';
import '../dialog/alert_dialogs.dart';

/// A helper [AsyncValue] extension to show an alert dialog on error
extension AsyncValueUI on AsyncValue {
  void showAlertDialogOnError(BuildContext context) {
    if (!isLoading && hasError) {
      final message = _errorMessage(error);
      showExceptionAlertDialog(
        context: context,
        title: 'Error',
        exception: message,
      );
    }
  }

  String _errorMessage(Object? error) {
    if (error is AppException) {
      return error.message;
    } else {
      final errors = error.toString().split(']');
      if (errors.length > 1) {
        return error.toString().split(']')[1].trim();
      } else {
        return error.toString();
      }
    }
  }
}
