import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'other_users_controller.g.dart';

@riverpod
class OtherUsersController extends _$OtherUsersController {
  @override
  FutureOr<void> build() {
    // return ;
  }
}

@Riverpod(keepAlive: true)
class OtherUsersStream extends _$OtherUsersStream {
  Stream<List<types.User>> _fetchUsers() {
    return FirebaseChatCore.instance.users();
  }

  @override
  Stream<List<types.User>> build() {
    return _fetchUsers();
  }
}
