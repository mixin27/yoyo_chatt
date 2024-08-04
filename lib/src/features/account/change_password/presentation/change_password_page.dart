import 'package:flutter/material.dart';

import 'package:auto_route/auto_route.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:iconly/iconly.dart';

import 'package:yoyo_chatt/src/features/account/change_password/presentation/change_password_page_controller.dart';
import 'package:yoyo_chatt/src/features/auth/presentation/sign_in/email_password_sign_in_form_type.dart';
import 'package:yoyo_chatt/src/features/auth/presentation/sign_in/emaill_password_validators.dart';
import 'package:yoyo_chatt/src/shared/constants.dart';
import 'package:yoyo_chatt/src/shared/extensions/dart_extensions.dart';
import 'package:yoyo_chatt/src/shared/utils/async/async_value_ui.dart';

@RoutePage()
class ChangePasswordPage extends StatefulHookConsumerWidget {
  const ChangePasswordPage({super.key});
  @override
  ConsumerState<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends ConsumerState<ChangePasswordPage>
    with EmailPasswordValidators {
  final _formKey = GlobalKey<FormState>();

  final _passwordController = TextEditingController();
  final _matchPasswordController = TextEditingController();

  String get password => _passwordController.text;
  String get matchPassword => _matchPasswordController.text;

  var _submitted = false;

  bool _secureText = true;

  @override
  void dispose() {
    // * TextEditingControllers should be always disposed
    _passwordController.dispose();
    _matchPasswordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _submitted = true);

      final controller =
          ref.read(changePasswordPageControllerProvider.notifier);

      final success = await controller.submit(newPassword: password);

      if (mounted) {
        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Change password request success.'),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Change password request failed.'),
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(
      changePasswordPageControllerProvider,
      (_, state) => state.showAlertDialogOnError(context),
    );

    final state = ref.watch(changePasswordPageControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('Change password'.hardcoded),
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: Sizes.p16),
            child: Text(
              'Change your password if you feel that your password has been known by others.'
                  .hardcoded,
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          gapH20,
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: Sizes.p16),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextFormField(
                    controller: _passwordController,
                    decoration: InputDecoration(
                      labelText: 'New password',
                      enabled: !state.isLoading,
                      border: const OutlineInputBorder(),
                      prefixIcon: const Icon(IconlyLight.password),
                      suffixIcon: IconButton(
                        onPressed: () =>
                            setState(() => _secureText = !_secureText),
                        icon: Icon(
                          _secureText ? Icons.visibility_off : Icons.visibility,
                        ),
                      ),
                    ),
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (password) => !_submitted
                        ? null
                        : passwordErrorText(password ?? '',
                            EmailPasswordSignInFormType.register),
                    obscureText: _secureText,
                    autocorrect: false,
                    textInputAction: TextInputAction.next,
                    keyboardAppearance: Brightness.light,
                  ),
                  gapH20,
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Re-type password',
                      enabled: !state.isLoading,
                      border: const OutlineInputBorder(),
                      prefixIcon: const Icon(IconlyLight.password),
                      suffixIcon: IconButton(
                        onPressed: () =>
                            setState(() => _secureText = !_secureText),
                        icon: Icon(
                          _secureText ? Icons.visibility_off : Icons.visibility,
                        ),
                      ),
                    ),
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (matchPass) {
                      if (!_submitted) return null;

                      if (password != matchPass) {
                        return 'Password do not match.';
                      }
                      return null;
                    },
                    obscureText: _secureText,
                    autocorrect: false,
                    textInputAction: TextInputAction.done,
                    keyboardAppearance: Brightness.light,
                  ),
                ],
              ),
            ),
          ),
          gapH20,
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: Sizes.p16),
            child: FilledButton(
              onPressed: state.isLoading ? null : () => _submit(),
              child: Text('Change password'.hardcoded),
            ),
          ),
        ],
      ),
    );
  }
}
