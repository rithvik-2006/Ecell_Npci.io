import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';

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
}
