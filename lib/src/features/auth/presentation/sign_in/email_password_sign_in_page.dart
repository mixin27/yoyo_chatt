import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:auto_route/annotations.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:iconly/iconly.dart';

import 'package:yoyo_chatt/src/shared/constants.dart';
import 'package:yoyo_chatt/src/shared/extensions.dart';
import 'package:yoyo_chatt/src/shared/mixins.dart';
import 'package:yoyo_chatt/src/shared/responsives.dart';
import 'package:yoyo_chatt/src/shared/widgets.dart';
import 'email_password_sign_in_controller.dart';
import 'email_password_sign_in_form_type.dart';
import 'emaill_password_validators.dart';

@RoutePage()
class EmailPasswordSignInPage extends StatelessWidget {
  const EmailPasswordSignInPage({
    super.key,
    this.formType = EmailPasswordSignInFormType.signIn,
    this.onSignedIn,
  });

  final EmailPasswordSignInFormType formType;
  final Function(bool success)? onSignedIn;

  // * Keys for testing using find.byKey()
  static const emailKey = Key('email');
  static const passwordKey = Key('password');
  static const firstNameKey = Key('first_name');
  static const lastNameKey = Key('last_name');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: context.colorScheme.primary,
      ),
      backgroundColor: context.colorScheme.primary,
      body: ListView(
        children: [
          gapH20,
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: Sizes.p16),
            child: Text(
              'Welcome to Yoyo Chatt',
              style: context.textTheme.headlineSmall!
                  .copyWith(color: Colors.white),
            ),
          ),
          gapH12,
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: Sizes.p16),
            child: Text(
              'Make your conversation with your lovely friends and family.',
              style:
                  context.textTheme.bodyMedium!.copyWith(color: Colors.white),
            ),
          ),
          gapH12,
          EmailPasswordSignInContent(
            formType: formType,
            onSignedIn: () => onSignedIn?.call(true),
          ),
        ],
      ),
    );
  }
}

class EmailPasswordSignInContent extends StatefulHookConsumerWidget {
  const EmailPasswordSignInContent({
    super.key,
    required this.formType,
    this.onSignedIn,
  });

  final VoidCallback? onSignedIn;

  /// The default form type to use.
  final EmailPasswordSignInFormType formType;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _EmailPasswordSignInContentState();
}

class _EmailPasswordSignInContentState
    extends ConsumerState<EmailPasswordSignInContent>
    with EmailPasswordValidators {
  // Input fields related
  final _formKey = GlobalKey<FormState>();
  final _node = FocusScopeNode();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();

  String get email => _emailController.text;
  String get password => _passwordController.text;
  String get firstName => _firstNameController.text;
  String get lastName => _lastNameController.text;

  bool _secureText = true;

  // local variable used to apply AutovalidateMode.onUserInteraction and show
  // error hints only when the form has been submitted
  // For more details on how this is implemented, see:
  // https://codewithandrea.com/articles/flutter-text-field-form-validation/
  var _submitted = false;

  // track the formType as a local state variable
  late var _formType = widget.formType;

  @override
  void dispose() {
    // * TextEditingControllers should be always disposed
    _node.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  /// Submit the form
  Future<void> _submit() async {
    setState(() => _submitted = true);

    if (_formKey.currentState!.validate()) {
      final controller =
          ref.read(emailPasswordSignInControllerProvider.notifier);

      final success = await controller.submit(
        email: email,
        password: password,
        formType: _formType,
        firstName: firstName,
        lastName: lastName,
      );

      if (success) {
        widget.onSignedIn?.call();
      }
    }
  }

  void _firstNameEditingComplete() {
    if (canSubmitName(firstName)) {
      _node.nextFocus();
    }
  }

  void _lastNameEditingComplete() {
    _node.nextFocus();
  }

  void _emailEditingComplete() {
    if (canSubmitEmail(email)) {
      _node.nextFocus();
    }
  }

  void _passwordEditingComplete() {
    if (!canSubmitEmail(email)) {
      _node.previousFocus();
      return;
    }

    _submit();
  }

  // If you want to support sign up function,
  // you can call this method to change form type to register.
  // ignore: unused_element
  void _updateFormType() {
    // * Toggle between register and sign in form
    setState(() => _formType = _formType.secondaryActionFormType);
    // * Clear the password field when doing so
    _passwordController.clear();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(
      emailPasswordSignInControllerProvider,
      (_, state) => state.showAlertDialogOnError(context),
    );

    final state = ref.watch(emailPasswordSignInControllerProvider);

    return ResponsiveScrollableCard(
      child: FocusScope(
        node: _node,
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (_formType == EmailPasswordSignInFormType.register) ...[
                gapH8,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // First Name
                    Expanded(
                      child: TextFormField(
                        key: EmailPasswordSignInPage.firstNameKey,
                        controller: _firstNameController,
                        decoration: InputDecoration(
                          labelText: 'First'.hardcoded,
                          hintText: 'John'.hardcoded,
                          enabled: !state.isLoading,
                          prefixIcon: const Icon(Icons.person),
                        ),
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (firstName) => !_submitted
                            ? null
                            : firstNameErrorText(firstName ?? ''),
                        autocorrect: false,
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.name,
                        keyboardAppearance: Brightness.light,
                        onEditingComplete: () => _firstNameEditingComplete(),
                      ),
                    ),
                    gapW8,
                    // Last Name
                    Expanded(
                      child: TextFormField(
                        key: EmailPasswordSignInPage.lastNameKey,
                        controller: _lastNameController,
                        decoration: InputDecoration(
                          labelText: 'Last'.hardcoded,
                          hintText: 'Doe'.hardcoded,
                          enabled: !state.isLoading,
                          prefixIcon: const Icon(Icons.person),
                        ),
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        autocorrect: false,
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.name,
                        keyboardAppearance: Brightness.light,
                        onEditingComplete: () => _lastNameEditingComplete(),
                      ),
                    ),
                  ],
                ),
              ],

              gapH8,
              // Email field
              TextFormField(
                key: EmailPasswordSignInPage.emailKey,
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email'.hardcoded,
                  hintText: 'test@test.com'.hardcoded,
                  enabled: !state.isLoading,
                  prefixIcon: const Icon(IconlyLight.message),
                ),
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (email) =>
                    !_submitted ? null : emailErrorText(email ?? ''),
                autocorrect: false,
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.emailAddress,
                keyboardAppearance: Brightness.light,
                onEditingComplete: () => _emailEditingComplete(),
                inputFormatters: <TextInputFormatter>[
                  ValidatorInputFormatter(
                      editingValidator: EmailEditingRegexValidator()),
                ],
              ),

              gapH8,

              // Password field
              TextFormField(
                key: EmailPasswordSignInPage.passwordKey,
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: _formType.passwordLabelText,
                  enabled: !state.isLoading,
                  prefixIcon: const Icon(IconlyLight.password),
                  suffixIcon: IconButton(
                    onPressed: () => setState(() => _secureText = !_secureText),
                    icon: Icon(
                        _secureText ? Icons.visibility_off : Icons.visibility),
                  ),
                ),
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (password) => !_submitted
                    ? null
                    : passwordErrorText(password ?? '', _formType),
                obscureText: _secureText,
                autocorrect: false,
                textInputAction: TextInputAction.done,
                keyboardAppearance: Brightness.light,
                onEditingComplete: () => _passwordEditingComplete(),
              ),

              gapH20,

              PrimaryButton(
                onPressed: state.isLoading ? null : () => _submit(),
                text: _formType.primaryButtonText,
                isLoading: state.isLoading,
              ),
              gapH8,
              TextButton(
                onPressed: state.isLoading ? null : _updateFormType,
                child: Text(_formType.secondaryButtonText),
              ),
              gapH20,
            ],
          ),
        ),
      ),
    );
  }
}
