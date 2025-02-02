import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  String? authToken;
  FirebaseAuth auth = FirebaseAuth.instance;

  Future<bool> checkLoggedInUser() async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      String? token = await user.getIdToken();
      authToken = token;
      return true;
    }

    log('No user is logged in.');
    return false;
  }

  Future<String?> loginUsingEmailAndPassword(String email, String password) async {
    try {
      UserCredential userCredential =
          await auth.signInWithEmailAndPassword(email: email, password: password);

      log('User: ${userCredential.user?.email}');
      String? token = await userCredential.user?.getIdToken();

      authToken = token;

      return token;
    } catch (err) {
      log('Error: $err');
      return null;
    }
  }

  Future<bool> resetPassword(String email) async {
    try {
      await auth.sendPasswordResetEmail(email: email);
      log('Email sent');
      return true;
    } catch (err) {
      log('FirebaseAuthException: $err');
      return false;
    }
  }

  Future<String?> loginWithGoogle() async {
    try {
      final GoogleSignIn googleSignIn = GoogleSignIn();
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

      log('GOogle sign in 1 $googleUser');

      if (googleUser == null) {
        return null;
      }

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);

      final String? token = await userCredential.user?.getIdToken();

      authToken = token;

      return token;
    } catch (err) {
      log('Error during Google signing: ${(err as PlatformException).message} ${(err).details} ${(err).code} ${(err).details} ${(err).stacktrace}');
      throw err;
      // return null;
    }
  }
}
