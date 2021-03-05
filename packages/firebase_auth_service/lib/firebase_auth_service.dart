library firebase_auth_service;

import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';

@immutable
class AppUser {
  final String uid;
  final String? email;
  final String? photoURL;
  final String? displayName;

  const AppUser({
    required this.uid,
    this.email,
    this.photoURL,
    this.displayName,
  });

  factory AppUser.fromFirebaseUser(User? user) {
    return AppUser(
      uid: user!.uid,
      email: user.email,
      photoURL: user.photoURL,
      displayName: user.displayName,
    );
  }

  @override
  String toString() =>
      '{uid: $uid, email: $email, photoURL: $photoURL, displayName: $displayName}';
}

class FirebaseAuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Stream<AppUser> authStateChanged() {
    return _firebaseAuth
        .authStateChanges()
        .map((user) => AppUser.fromFirebaseUser(user));
  }

  Future<AppUser> createUserWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    return AppUser.fromFirebaseUser(userCredential.user);
  }

  Future<AppUser> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    final userCredential = await _firebaseAuth.signInWithCredential(
      EmailAuthProvider.credential(
        email: email,
        password: password,
      ),
    );
    return AppUser.fromFirebaseUser(userCredential.user);
  }

  AppUser get currentUser =>
      AppUser.fromFirebaseUser(_firebaseAuth.currentUser);

  Future<void> signOut() async => _firebaseAuth.signOut();
}
