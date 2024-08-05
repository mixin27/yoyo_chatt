import 'package:flutter/material.dart';

import 'package:auto_route/annotations.dart';
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
class ChangePasswordPage extends StatelessWidget {
  const ChangePasswordPage({
    super.key,
  });

  // * Keys for testing using find.byKey()
  static const passwordKey = Key('password');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Change password'.hardcoded)),
      body: ListView(
        children: [
          gapH20,
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: Sizes.p16),
            child: Text(
              'Change your password if you feel that your password has been known by others.'
                  .hardcoded,
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          gapH12,
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: Sizes.p16),
            child: ChangePasswordContent(),
          ),
        ],
      ),
    );
  }
}

class ChangePasswordContent extends StatefulHookConsumerWidget {
  const ChangePasswordContent({
    super.key,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _EmailPasswordSignInContentState();
}

class _EmailPasswordSignInContentState
    extends ConsumerState<ChangePasswordContent> with EmailPasswordValidators {
  // Input fields related
  final _formKey = GlobalKey<FormState>();
  final _node = FocusScopeNode();

  final _passwordController = TextEditingController();

  String get password => _passwordController.text;

  bool _secureText = true;

  var _submitted = false;

  @override
  void dispose() {
    // * TextEditingControllers should be always disposed
    _node.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  /// Submit the form
  Future<void> _submit() async {
    setState(() => _submitted = true);

    if (_formKey.currentState!.validate()) {
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

    return FocusScope(
      node: _node,
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Email field
            TextFormField(
              key: ChangePasswordPage.passwordKey,
              controller: _passwordController,
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                labelText: 'New Password'.hardcoded,
                enabled: !state.isLoading,
                prefixIcon: const Icon(IconlyLight.password),
              ),
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (pass) => !_submitted
                  ? null
                  : passwordErrorText(
                      pass ?? '', EmailPasswordSignInFormType.register),
              autocorrect: false,
              textInputAction: TextInputAction.next,
              keyboardType: TextInputType.visiblePassword,
              keyboardAppearance: Brightness.light,
            ),

            gapH8,

            // Password field
            TextFormField(
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                labelText: 'Re-type password'.hardcoded,
                enabled: !state.isLoading,
                prefixIcon: const Icon(IconlyLight.password),
                suffixIcon: IconButton(
                  onPressed: () => setState(() => _secureText = !_secureText),
                  icon: Icon(
                      _secureText ? Icons.visibility_off : Icons.visibility),
                ),
              ),
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (match) {
                if (!_submitted) return null;

                if (match != _passwordController.text) {
                  return 'Passwords do not match';
                }

                return null;
              },
              obscureText: _secureText,
              autocorrect: false,
              textInputAction: TextInputAction.done,
              keyboardAppearance: Brightness.light,
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
      ),
    );
  }
}
