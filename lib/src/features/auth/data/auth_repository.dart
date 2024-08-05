import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:yoyo_chatt/src/features/auth/data/firebase_app_user.dart';
import 'package:yoyo_chatt/src/features/auth/domain/app_user.dart';

part 'auth_repository.g.dart';

class AuthRepository {
  const AuthRepository(this._auth);

  final FirebaseAuth _auth;
  // final FirebaseFirestore _store;

  Future<void> signInWithEmailAndPassword(String email, String password) {
    return _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<void> createUserWithEmailAndPassword(
    String email,
    String password,
    String firstName, [
    String? lastName,
  ]) async {
    final credential = await _auth.createUserWithEmailAndPassword(
        email: email, password: password);
    if (credential.user == null) throw Exception('Error on creating account.');

    await FirebaseChatCore.instance.createUserInFirestore(
      types.User(
        id: credential.user!.uid,
        firstName: firstName,
        lastName: lastName,
        imageUrl:
            'https://firebasestorage.googleapis.com/v0/b/yoyo-chatt.appspot.com/o/assets%2Fplaystore.png?alt=media&token=25be8c47-8a37-40de-bd8a-4ed0540a89eb',
      ),
    );
  }

  Future<void> signOut() async {
    final user = _auth.currentUser;
    final usersCollectionRef = FirebaseFirestore.instance.collection('users');
    await usersCollectionRef.doc(user!.uid).update({
      'lastSeen': FieldValue.serverTimestamp(),
    });

    return _auth.signOut();
  }

  /// Notifies about changes to the user's sign-in state (such as sign-in or
  /// sign-out).
  Stream<AppUser?> authStateChanges() {
    return _auth.authStateChanges().map(_convertUser);
  }

  /// Notifies about changes to the user's sign-in state (such as sign-in or
  /// sign-out) and also token refresh events.
  Stream<AppUser?> idTokenChanges() {
    return _auth.idTokenChanges().map(_convertUser);
  }

  AppUser? get currentUser => _convertUser(_auth.currentUser);

  /// Helper method to convert a [User] to an [AppUser]
  AppUser? _convertUser(User? user) =>
      user != null ? FirebaseAppUser(user) : null;
}

@Riverpod(keepAlive: true)
AuthRepository authRepository(AuthRepositoryRef ref) {
  return AuthRepository(FirebaseAuth.instance);
}

// * Using keepAlive since other providers need it to be an
// * [AlwaysAliveProviderListenable]
@Riverpod(keepAlive: true)
Stream<AppUser?> authStateChanges(AuthStateChangesRef ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return authRepository.authStateChanges();
}

@Riverpod(keepAlive: true)
Stream<AppUser?> idTokenChanges(IdTokenChangesRef ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return authRepository.idTokenChanges();
}
