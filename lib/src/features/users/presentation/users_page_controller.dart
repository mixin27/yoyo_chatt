import 'package:flutter_chat_types/flutter_chat_types.dart';
import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'users_page_controller.g.dart';

@riverpod
class UsersPageController extends _$UsersPageController {
  @override
  FutureOr<void> build() {
    // return ;
  }
}

@Riverpod(keepAlive: true)
class UsersListStream extends _$UsersListStream {
  Stream<List<User>> _fetchUsers() {
    return FirebaseChatCore.instance.users();
  }

  @override
  Stream<List<User>> build() {
    return _fetchUsers();
  }
}
