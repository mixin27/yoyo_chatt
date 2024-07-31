import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:yoyo_chatt/src/features/auth/data/auth_repository.dart';

part 'logout_tile_controller.g.dart';

@riverpod
class LogoutTileController extends _$LogoutTileController {
  @override
  FutureOr<void> build() {
    // return ;
  }

  Future<void> logout() async {
    final authRepository = ref.read(authRepositoryProvider);
    await authRepository.signOut();
  }
}
