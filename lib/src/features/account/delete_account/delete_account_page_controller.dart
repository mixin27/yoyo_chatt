import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:yoyo_chatt/src/features/auth/data/auth_repository.dart';

part 'delete_account_page_controller.g.dart';

@riverpod
class DeleteAccountPageController extends _$DeleteAccountPageController {
  @override
  FutureOr<void> build() {
    // return ;
  }

  Future<bool> submit({
    required String email,
  }) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _deleteAccount(email));
    return state.hasError == false;
  }

  Future<void> _deleteAccount(String email) async {
    final authRepository = ref.read(authRepositoryProvider);
    final currentUser = authRepository.currentUser;
    if (currentUser == null) {
      throw Exception('User is not signed in.');
    }

    final docRef =
        FirebaseFirestore.instance.collection('users').doc(currentUser.uid);
    await docRef.update({
      'metadata': {
        'email': email,
        'delete_request': true,
      },
    });
  }
}
