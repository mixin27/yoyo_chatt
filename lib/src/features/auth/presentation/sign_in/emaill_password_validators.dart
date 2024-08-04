import 'package:yoyo_chatt/src/shared/extensions.dart';
import 'package:yoyo_chatt/src/shared/mixins.dart';
import 'email_password_sign_in_form_type.dart';

/// Mixin class to be used for client-side email & password validation
mixin EmailPasswordValidators {
  final StringValidator emailSubmitValidator = EmailSubmitRegexValidator();
  final StringValidator passwordRegisterSubmitValidator =
      MinLengthStringValidator(8);
  final StringValidator passwordSignInSubmitValidator =
      NonEmptyStringValidator();
  final StringValidator nameValidator = NonEmptyStringValidator();

  bool canSubmitEmail(String email) {
    return emailSubmitValidator.isValid(email);
  }

  bool canSubmitPassword(
      String password, EmailPasswordSignInFormType formType) {
    if (formType == EmailPasswordSignInFormType.register) {
      return passwordRegisterSubmitValidator.isValid(password);
    }
    return passwordSignInSubmitValidator.isValid(password);
  }

  bool canSubmitName(String name) {
    return nameValidator.isValid(name);
  }

  String? emailErrorText(String email) {
    final bool showErrorText = !canSubmitEmail(email);
    final String errorText = email.isEmpty
        ? 'Email can\'t be empty'.hardcoded
        : 'Invalid email'.hardcoded;
    return showErrorText ? errorText : null;
  }

  String? passwordErrorText(
      String password, EmailPasswordSignInFormType formType) {
    final bool showErrorText = !canSubmitPassword(password, formType);
    final String errorText = password.isEmpty
        ? 'Password can\'t be empty'.hardcoded
        : 'Password is too short'.hardcoded;
    return showErrorText ? errorText : null;
  }

  String? firstNameErrorText(String firstName) {
    final bool showErrorText = !canSubmitName(firstName);
    final String errorText = firstName.isEmpty
        ? 'First name can\'t be empty'.hardcoded
        : 'Invalid name'.hardcoded;
    return showErrorText ? errorText : null;
  }

  // String? lastNameErrorText(String lastName) {
  //   final bool showErrorText = !canSubmitName(lastName);
  //   final String errorText = lastName.isEmpty
  //       ? 'Last name can\'t be empty'.hardcoded
  //       : 'Invalid name'.hardcoded;
  //   return showErrorText ? errorText : null;
  // }
}
