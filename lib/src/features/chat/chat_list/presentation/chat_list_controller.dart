import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'chat_list_controller.g.dart';

@riverpod
class ChatListController extends _$ChatListController {
  @override
  FutureOr<void> build() {
    // return ;
  }
}

@riverpod
class ChatListStream extends _$ChatListStream {
  Stream<List<types.Room>> _fetchRooms() {
    return FirebaseChatCore.instance.rooms();
  }

  @override
  Stream<List<types.Room>> build() {
    return _fetchRooms();
  }
}
