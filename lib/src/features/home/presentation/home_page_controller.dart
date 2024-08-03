import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:yoyo_chatt/src/features/auth/data/auth_repository.dart';

part 'home_page_controller.g.dart';

@riverpod
class HomePageController extends _$HomePageController {
  @override
  FutureOr<void> build() {
    // return ;
  }

  Future<void> logout() async {
    final authRepository = ref.read(authRepositoryProvider);

    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await authRepository.signOut();
    });
  }

  Future<void> setLastSeen() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final usersCollectionRef = FirebaseFirestore.instance.collection('users');
    await usersCollectionRef.doc(user.uid).update({
      'lastSeen': FieldValue.serverTimestamp(),
    });
  }
}
