import 'package:flutter_chat_types/flutter_chat_types.dart';
import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'create_group_chat_controller.g.dart';

@riverpod
class CreateGroupChatController extends _$CreateGroupChatController {
  @override
  FutureOr<void> build() {
    // return ;
  }

  Future<Room> createGroupChat({
    required String name,
    required List<User> users,
    String? imageUrl,
    Map<String, dynamic>? metadata,
  }) async {
    final room = await FirebaseChatCore.instance.createGroupRoom(
      name: name,
      users: users,
      imageUrl: imageUrl,
      metadata: metadata,
    );

    return room;
  }
}
