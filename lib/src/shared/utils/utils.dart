import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:native_id/native_id.dart';
import 'package:timeago/timeago.dart' as timeago;

import 'package:yoyo_chatt/src/shared/extensions.dart';

Future<String?> getNativeDeviceId() async {
  try {
    final nativeIdPlugin = NativeId();

    return await nativeIdPlugin.getId();
  } on PlatformException catch (e) {
    debugPrint('Error(native_id): ${e.message}');

    return null;
  }
}

types.User getOtherUserFromRoom(List<types.User> users) {
  return users
      .firstWhere((user) => user.id != FirebaseAuth.instance.currentUser?.uid);
}

types.User getUserFromRoom(List<types.User> users) {
  return users
      .firstWhere((user) => user.id == FirebaseAuth.instance.currentUser?.uid);
}

String getNameFromUser(types.User user) {
  return '${user.firstName} ${user.lastName}';
}

String getFullName(String? firstName, String? lastName) {
  if (firstName.isNullOrEmpty && lastName.isNullOrEmpty) return '';
  if (!firstName.isNullOrEmpty && lastName.isNullOrEmpty) return firstName!;
  if (firstName.isNullOrEmpty && !lastName.isNullOrEmpty) return lastName!;
  return '$firstName $lastName';
}

String getLastSeenTime(int lastSeen) {
  final lastSeenDateTime = DateTime.fromMillisecondsSinceEpoch(lastSeen);
  return timeago.format(lastSeenDateTime);
}
