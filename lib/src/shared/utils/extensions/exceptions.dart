/// Base class for all all client-side errors that can be generated by the app
sealed class AppException implements Exception {
  AppException(this.code, this.message);
  final String code;
  final String message;

  @override
  String toString() => message;
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

class UserNotSignedInException extends AppException {
  UserNotSignedInException()
      : super('user-not-signed-in',
            'The operation can\'t be completed (not signed in)');
}
