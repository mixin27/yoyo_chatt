import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'home_bottom_nav_controller.g.dart';

@riverpod
class HomeBottomNavController extends _$HomeBottomNavController {
  @override
  int build() {
    return 0;
  }

  void setIndex(int index) => state = index;

  void setAndPersistValue(int index) {
    state = index;
    // Persist value to local storage
  }
}
