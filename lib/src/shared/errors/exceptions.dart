/// Base class for all all client-side errors that can be generated by the app
sealed class AppException implements Exception {
  AppException(this.code, this.message);
  final String code;
  final String message;

  @override
  String toString() => message;
}

class UnknownException extends AppException {
  UnknownException([String? code, String? message])
      : super(
          code ?? 'unknown',
          message ?? 'Something went wrong! Please try again.',
        );
}

/// Auth
class InvalidLoginCredentialsException extends AppException {
  InvalidLoginCredentialsException()
      : super('invalid-login-credentials', 'Invalid login credentials');
}

class EmailAlreadyInUseException extends AppException {
  EmailAlreadyInUseException()
      : super('email-already-in-use', 'Email already in use');
}

class WeakPasswordException extends AppException {
  WeakPasswordException() : super('weak-password', 'Password is too weak');
}

class WrongPasswordException extends AppException {
  WrongPasswordException() : super('wrong-password', 'Wrong password');
}

class UserNotFoundException extends AppException {
  UserNotFoundException() : super('user-not-found', 'User not found');
}
