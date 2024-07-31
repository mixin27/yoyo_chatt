import 'package:firebase_auth/firebase_auth.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:yoyo_chatt/src/features/auth/data/auth_repository.dart';
import 'package:yoyo_chatt/src/shared/errors.dart';
import 'email_password_sign_in_form_type.dart';

part 'email_password_sign_in_controller.g.dart';

@riverpod
class EmailPasswordSignInController extends _$EmailPasswordSignInController {
  @override
  FutureOr<void> build() {
    // return ;
  }

  Future<bool> submit({
    required String email,
    required String password,
    required EmailPasswordSignInFormType formType,
  }) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(
      () => _authenticate(email, password, formType),
    );
    return state.hasError == false;
  }

  Future<void> _authenticate(
    String email,
    String password,
    EmailPasswordSignInFormType formType,
  ) async {
    final authRepository = ref.read(authRepositoryProvider);

    if (formType == EmailPasswordSignInFormType.signIn) {
      try {
        await authRepository.signInWithEmailAndPassword(email, password);
      } on FirebaseAuthException catch (e) {
        if (e.message != null &&
            e.message!.contains('INVALID_LOGIN_CREDENTIALS ')) {
          throw InvalidLoginCredentialsException();
        } else {
          throw Exception('Error on account login. Please try again.');
        }
      }
    } else {
      await authRepository.createUserWithEmailAndPassword(email, password);
    }
  }
}
