import 'dart:developer';

import 'package:flutter/material.dart';

import 'package:auto_route/auto_route.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:iconly/iconly.dart';

import 'package:yoyo_chatt/src/features/account/account_settings/presentation/account_settings_page_controller.dart';
import 'package:yoyo_chatt/src/shared/extensions/dart_extensions.dart';

@RoutePage()
class AccountEmailPage extends HookConsumerWidget {
  const AccountEmailPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userState = ref.watch(currentUserStreamProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('Email'.hardcoded),
      ),
      body: userState.when(
        data: (user) {
          if (user == null) return const SizedBox();

          log('verify: ${user.emailVerified}');
          return ListView(
            children: [
              ListTile(
                leading: const Icon(IconlyLight.message),
                title: Text(user.email!),
                trailing: !user.emailVerified
                    ? TextButton(
                        onPressed: () {
                          user.sendEmailVerification();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Verification email has been sent.'.hardcoded,
                              ),
                            ),
                          );
                        },
                        child: Text('verify'.hardcoded),
                      )
                    : const Icon(
                        Icons.verified_outlined,
                        color: Colors.green,
                      ),
              ),
            ],
          );
        },
        error: (_, error) => Center(
          child: Text(error.toString()),
        ),
        loading: () => const Center(
          child: CircularProgressIndicator.adaptive(),
        ),
      ),
    );
  }
}
