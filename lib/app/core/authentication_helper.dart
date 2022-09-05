import 'package:firebase_auth/firebase_auth.dart';

class AuthenticationHelper {

  final FirebaseAuth _auth = FirebaseAuth.instance;
  get userMail => _auth.currentUser?.email;

  /// Sign up
  Future<User?> signUp(String email, String password) async {
    try {
      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return _auth.currentUser;
    } on FirebaseAuthException catch (_) {
      return null;
    }
  }

  /// Sign in
  Future<User?> signIn(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      return _auth.currentUser;
    } on FirebaseAuthException catch (_) {
      return null;
    }
  }

  /// Sign out
  Future signOut() async {
    await _auth.signOut();
  }
}