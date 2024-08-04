import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:auto_route/auto_route.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:iconly/iconly.dart';

import 'package:yoyo_chatt/src/features/account/delete_account/delete_account_page_controller.dart';
import 'package:yoyo_chatt/src/features/auth/presentation/sign_in/emaill_password_validators.dart';
import 'package:yoyo_chatt/src/shared/constants.dart';
import 'package:yoyo_chatt/src/shared/extensions/dart_extensions.dart';
import 'package:yoyo_chatt/src/shared/mixins.dart';
import 'package:yoyo_chatt/src/shared/utils/async/async_value_ui.dart';

@RoutePage()
class DeleteAccountPage extends StatefulHookConsumerWidget {
  const DeleteAccountPage({super.key});
  @override
  ConsumerState<DeleteAccountPage> createState() => _DeleteAccountPageState();
}

class _DeleteAccountPageState extends ConsumerState<DeleteAccountPage>
    with EmailPasswordValidators {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

  String get email => _emailController.text;

  var _submitted = false;

  @override
  void dispose() {
    // * TextEditingControllers should be always disposed
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    setState(() => _submitted = true);

    if (_formKey.currentState!.validate()) {
      final controller = ref.read(deleteAccountPageControllerProvider.notifier);

      final success = await controller.submit(email: email);

      if (success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Delete account request success.'),
          ),
        );
      } else if (!success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Delete account request failed.'),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(
      deleteAccountPageControllerProvider,
      (_, state) => state.showAlertDialogOnError(context),
    );

    final state = ref.watch(deleteAccountPageControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('Delete this account'.hardcoded),
      ),
      body: Padding(
        padding: const EdgeInsets.all(Sizes.p16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  IconlyLight.danger,
                  color: Theme.of(context).colorScheme.error,
                ),
                gapW16,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'If you delete this account:',
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  color: Theme.of(context).colorScheme.error,
                                  fontWeight: FontWeight.w700,
                                ),
                      ),
                      gapH12,
                      const BulletText(
                        text: 'This account will be deleted from Yoyo Chatt',
                      ),
                      gapH4,
                      const BulletText(
                        text: 'Your message history will be erased',
                      ),
                      gapH4,
                      const BulletText(
                        text:
                            'You will be removed from all your Yoyo Chatt groups',
                      ),
                      gapH4,
                      const BulletText(
                        text:
                            'After deleting request success, your account will be deleted within 30 days.',
                      ),
                      gapH4,
                      const BulletText(
                        text:
                            'Logout your account after you\'ve deleted and don\'t sign in again within 30 days.',
                      ),
                      gapH24,
                      Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            TextFormField(
                              controller: _emailController,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Email',
                                prefixIcon: Icon(IconlyLight.message),
                              ),
                              validator: (email) => !_submitted
                                  ? null
                                  : emailErrorText(email ?? ''),
                              inputFormatters: <TextInputFormatter>[
                                ValidatorInputFormatter(
                                  editingValidator:
                                      EmailEditingRegexValidator(),
                                ),
                              ],
                              textInputAction: TextInputAction.done,
                              keyboardType: TextInputType.emailAddress,
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              enabled: !state.isLoading,
                            ),
                          ],
                        ),
                      ),
                      gapH20,
                      FilledButton(
                        onPressed: state.isLoading ? null : () => _submit(),
                        style: FilledButton.styleFrom(
                          backgroundColor: Theme.of(context).colorScheme.error,
                          foregroundColor:
                              Theme.of(context).colorScheme.onError,
                        ),
                        child: Text('Delete account'.hardcoded),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class BulletText extends StatelessWidget {
  const BulletText({
    super.key,
    required this.text,
    this.bulletColor,
    this.textStyle,
  });

  final String text;
  final Color? bulletColor;
  final TextStyle? textStyle;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          '\u2022',
          style: TextStyle(fontSize: 30, color: bulletColor),
        ),
        gapW8,
        Expanded(child: Text(text, style: textStyle)),
      ],
    );
  }
}
