import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart';
import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'chat_message_member_controller.g.dart';

@riverpod
class ChatRoomStream extends _$ChatRoomStream {
  Stream<Room> _fetchRoom(String roomId) {
    return FirebaseChatCore.instance.room(roomId);
  }

  @override
  Stream<Room> build(String roomId) {
    return _fetchRoom(roomId);
  }
}

@riverpod
class ChatRoomAdminStream extends _$ChatRoomAdminStream {
  Stream<Map<String, dynamic>?> _fetchChatRoomAdmin(String roomId) {
    return FirebaseFirestore.instance
        .collection('rooms')
        .doc(roomId)
        .snapshots()
        .map((doc) {
      final data = doc.data();
      if (data == null) return null;

      data['userRoles'] = data['userRoles'];

      return data;
    });
  }

  @override
  Stream<Map<String, dynamic>?> build(String roomId) {
    return _fetchChatRoomAdmin(roomId);
  }
}

@riverpod
class ChatMemberStream extends _$ChatMemberStream {
  Stream<User?> _fetchMemberData(String userId) {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .snapshots()
        .map((doc) {
      final data = doc.data();
      if (data == null) return null;

      data['createdAt'] = data['createdAt']?.millisecondsSinceEpoch;
      data['id'] = doc.id;
      data['lastSeen'] = data['lastSeen']?.millisecondsSinceEpoch;
      data['updatedAt'] = data['updatedAt']?.millisecondsSinceEpoch;

      return User.fromJson(data);
    });
  }

  @override
  Stream<User?> build(String userId) {
    return _fetchMemberData(userId);
  }
}
