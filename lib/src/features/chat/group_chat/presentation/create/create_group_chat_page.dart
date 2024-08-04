import 'dart:developer';

import 'package:flutter/material.dart';

import 'package:auto_route/auto_route.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:iconly/iconly.dart';

import 'package:yoyo_chatt/src/features/account/other_users/presentation/other_users_controller.dart';
import 'package:yoyo_chatt/src/routes/routes.dart';
import 'package:yoyo_chatt/src/shared/constants/app_sizes.dart';
import 'package:yoyo_chatt/src/shared/extensions/dart_extensions.dart';
import 'package:yoyo_chatt/src/shared/utils/async/async_value_ui.dart';
import 'package:yoyo_chatt/src/shared/utils/utils.dart';
import 'create_group_chat_controller.dart';

@RoutePage()
class CreateGroupChatPage extends StatefulHookConsumerWidget {
  const CreateGroupChatPage({super.key});
  @override
  ConsumerState<CreateGroupChatPage> createState() =>
      _CreateGroupChatPageState();
}

class _CreateGroupChatPageState extends ConsumerState<CreateGroupChatPage> {
  final List<User> _items = [];
  final List<User> _allUsers = [];
  final List<User> _searchResults = [];

  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();

  final _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    ref.listen(
      otherUsersStreamProvider,
      (_, state) {
        state.showAlertDialogOnError(context);

        state.maybeWhen(
          orElse: () {},
          data: (users) {
            setState(() {
              _allUsers.addAll(users);
            });
          },
        );
      },
    );

    final otherUsersState = ref.watch(otherUsersStreamProvider);

    void handleCreateGroupChat() async {
      log('items: ${_items.length}');

      if (_formKey.currentState!.validate()) {
        final name = _nameController.text;
        log('Name: $name');

        final room = await ref
            .read(createGroupChatControllerProvider.notifier)
            .createGroupChat(
              name: name,
              users: _items,
              imageUrl:
                  'https://firebasestorage.googleapis.com/v0/b/yoyo-chatt.appspot.com/o/assets%2Fchattchatt.png?alt=media&token=492521e2-6b32-4e35-bab7-754ad23a029b',
            );

        if (context.mounted) {
          context.router.replace(ChatMessageRoute(roomId: room.id, room: room));
        }
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Create Group'.hardcoded),
        actions: [
          TextButton(
            onPressed: _items.isEmpty ? null : handleCreateGroupChat,
            child: Text('Create'.hardcoded),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(Sizes.p8),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      hintText: 'Name'.hardcoded,
                    ),
                    keyboardType: TextInputType.name,
                    validator: (value) {
                      if (value.isNullOrEmpty) return 'Name is required';
                      return null;
                    },
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(Sizes.p8),
            child: Text(
              'Select people',
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
          ),
          gapH12,
          Padding(
            padding: const EdgeInsets.all(Sizes.p8),
            child: TextFormField(
              controller: _searchController,
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                hintText: 'Search'.hardcoded,
                prefixIcon: const Icon(IconlyLight.search),
              ),
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.search,
              onChanged: (keyword) {
                final items = _allUsers
                    .where((e) => getFullName(e.firstName, e.lastName)
                        .toLowerCase()
                        .contains(keyword.toLowerCase()))
                    .toList();
                setState(() {
                  _searchResults.addAll(items);
                });
              },
            ),
          ),
          gapH12,
          Expanded(
            child: otherUsersState.when(
              data: (users) {
                if (users.isEmpty) {
                  return Center(
                    child: Text('No users found.'.hardcoded),
                  );
                }

                return ListView.builder(
                  itemCount: _searchResults.isNotEmpty
                      ? _searchResults.length
                      : users.length,
                  itemBuilder: (context, index) {
                    final user = _searchResults.isNotEmpty
                        ? _searchResults[index]
                        : users[index];

                    return CheckboxListTile.adaptive(
                      title: Text(getFullName(user.firstName, user.lastName)),
                      value: _searchResults.isNotEmpty
                          ? _searchResults.contains(user)
                          : _items.contains(user),
                      onChanged: (checked) {
                        if (checked == true) {
                          setState(() {
                            _items.add(user);
                          });
                        } else {
                          setState(() {
                            _items.remove(user);
                          });
                        }
                      },
                      secondary: user.imageUrl != null
                          ? CircleAvatar(
                              radius: 28,
                              child: CircleAvatar(
                                radius: 24,
                                backgroundColor: Colors.grey.shade300,
                                child: CachedNetworkImage(
                                  imageUrl: user.imageUrl ?? '',
                                  imageBuilder: (context, imageProvider) =>
                                      Container(
                                    margin: const EdgeInsets.all(Sizes.p4),
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        image: imageProvider,
                                        fit: BoxFit.cover,
                                      ),
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  placeholder: (context, url) => const Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                  errorWidget: (context, url, error) =>
                                      const Center(
                                    child: Icon(Icons.broken_image_outlined),
                                  ),
                                ),
                              ),
                            )
                          : null,
                    );
                  },
                );
              },
              error: (error, _) => Center(
                child: Text(error.toString()),
              ),
              loading: () => const Center(
                child: CircularProgressIndicator.adaptive(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
