import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:yoyo_chatt/src/features/auth/data/auth_repository.dart';

part 'change_password_page_controller.g.dart';

@riverpod
class ChangePasswordPageController extends _$ChangePasswordPageController {
  @override
  FutureOr<void> build() {
    // return ;
  }

  Future<bool> submit({required String newPassword}) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _submit(newPassword));

    return state.hasError == false;
  }

  Future<void> _submit(String newPassword) async {
    final authRepository = ref.read(authRepositoryProvider);
    final fu = authRepository.currentUser;
    if (fu == null) {
      throw Exception('User is not signed in.');
    }

    await fu.changePassword(newPassword);
  }
}
