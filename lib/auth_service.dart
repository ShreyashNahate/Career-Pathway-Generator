import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthService with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? get currentUser => _user;
  User? _user;

  User? get user => _user;
  AuthService() {
    _auth.authStateChanges().listen((User? user) {
      _user = user;
      notifyListeners();
      if (user != null) {
        print('User signed in with UID: ${user.uid}');
      } else {
        print('User signed out.');
      }
    });
  }

  Future<String?> signIn(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      return null; // Success
    } on FirebaseAuthException catch (e) {
      print('Firebase Auth Error during sign-in: ${e.code}');
      return e.message; // Return error message
    } catch (e) {
      print('General error during sign-in: $e');
      return 'An unexpected error occurred.';
    }
  }

  Future<String?> signUp(String email, String password) async {
    try {
      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return null; // Success
    } on FirebaseAuthException catch (e) {
      print('Firebase Auth Error during sign-up: ${e.code}');
      return e.message;
    } catch (e) {
      print('General error during sign-up: $e');
      return 'An unexpected error occurred.';
    }
  }

  Future<void> signOut() async {
    try {
      await _auth.signOut();
      print('Sign out successful.');
    } catch (e) {
      print('Error during sign out: $e');
    }
  }
}
