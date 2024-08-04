import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart';
import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';
import 'package:image_picker/image_picker.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:yoyo_chatt/src/features/auth/data/auth_repository.dart';

part 'profile_controller.g.dart';

@riverpod
class ProfileController extends _$ProfileController {
  @override
  FutureOr<void> build() {
    // return ;
  }

  Future<String?> uploadImage(XFile result) async {
    final currentUser = FirebaseChatCore.instance.firebaseUser;
    if (currentUser == null) return null;

    final file = File(result.path);
    final name = result.name;

    final reference =
        FirebaseStorage.instance.ref('profiles/${currentUser.uid}/$name');
    await reference.putFile(file);
    final uri = await reference.getDownloadURL();

    return state.hasError ? null : uri;
  }

  Future<void> updateProfileAvatar(String avatarUrl) async {
    final currentUser = FirebaseChatCore.instance.firebaseUser;
    if (currentUser == null) return;

    final docRef =
        FirebaseFirestore.instance.collection('users').doc(currentUser.uid);
    await docRef.update({'imageUrl': avatarUrl});
  }
}

@riverpod
class UploadAvatar extends _$UploadAvatar {
  Future<String> _uploadFile(XFile xfile) async {
    final currentUser = FirebaseChatCore.instance.firebaseUser;
    if (currentUser == null) return '';

    final file = File(xfile.path);
    final name = xfile.name;

    final reference =
        FirebaseStorage.instance.ref('profiles/${currentUser.uid}/$name');
    await reference.putFile(file);
    final uri = await reference.getDownloadURL();
    return uri;
  }

  @override
  FutureOr<String> build(XFile xfile) {
    return _uploadFile(xfile);
  }
}

@riverpod
class ProfileData extends _$ProfileData {
  Stream<User?> _fetchProfileData() {
    final authRepository = ref.read(authRepositoryProvider);
    final user = authRepository.currentUser;
    if (user == null) return Stream.value(null);

    return FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .snapshots()
        .map((snapshot) {
      final data = snapshot.data();
      if (data == null) return null;

      data['createdAt'] = data['createdAt']?.millisecondsSinceEpoch;
      data['id'] = snapshot.id;
      data['lastSeen'] = data['lastSeen']?.millisecondsSinceEpoch;
      data['updatedAt'] = data['updatedAt']?.millisecondsSinceEpoch;
      return User.fromJson(data);
    });
  }

  @override
  Stream<User?> build() {
    return _fetchProfileData();
  }
}
