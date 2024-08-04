import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:yoyo_chatt/src/features/auth/data/auth_repository.dart';
import 'package:yoyo_chatt/src/features/auth/domain/app_user.dart';

part 'account_settings_page_controller.g.dart';

@riverpod
class AccountSettingsPageController extends _$AccountSettingsPageController {
  @override
  FutureOr<void> build() {
    // return ;
  }
}

@riverpod
class CurrentUserStream extends _$CurrentUserStream {
  @override
  Stream<AppUser?> build() {
    final authRepository = ref.read(authRepositoryProvider);
    return authRepository.authStateChanges();
  }
}
