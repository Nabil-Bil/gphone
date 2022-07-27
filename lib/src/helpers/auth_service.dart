import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:gphone/src/screens/auth_choice_screen.dart';
import 'package:gphone/src/screens/main_screen.dart';
import 'package:path/path.dart' as path;

class AuthService {
  static Widget handleAuthState() {
    return StreamBuilder(
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return const MainScreen();
        } else {
          return const AuthChoiceScreen();
        }
      },
      stream: FirebaseAuth.instance.authStateChanges(),
    );
  }

  static Future<UserCredential> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser =
        await GoogleSignIn(scopes: <String>["email"]).signIn();

    final GoogleSignInAuthentication googleAuth =
        await googleUser!.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(credential);

    // Obtain the auth details from the request
  }

  static Future<UserCredential> signInWithFacebook() async {
    // Trigger the sign-in flow
    final LoginResult loginResult = await FacebookAuth.instance.login();

    // Create a credential from the access token
    final OAuthCredential facebookAuthCredential =
        FacebookAuthProvider.credential(loginResult.accessToken!.token);

    // Once signed in, return the UserCredential
    return FirebaseAuth.instance.signInWithCredential(facebookAuthCredential);
  }

  static Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
  }

  static Future<UserCredential> signUpWithCredential(
      String email, String password) async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email.trim(), password: password.trim());
      return await signInWithCredential(email, password);
    } on FirebaseAuthException {
      rethrow;
    }
  }

  static Future<UserCredential> signInWithCredential(
      String email, String password) async {
    try {
      return FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password)
          .then((value) {
        return value;
      });
    } on FirebaseException {
      rethrow;
    }
  }

  static Future<void> updateProfilePicture(File file) async {
    String fileName =
        "${DateTime.now().toIso8601String()}${FirebaseAuth.instance.currentUser!.uid}${path.extension(file.path)}";

    final Reference ref =
        FirebaseStorage.instance.ref().child("profilePictures/$fileName");
    UploadTask uploadTask = ref.putFile(file);
    await uploadTask.whenComplete(() => null);
    if (FirebaseAuth.instance.currentUser!.photoURL != null) {
      try {
        FirebaseStorage.instance
            .refFromURL(FirebaseAuth.instance.currentUser!.photoURL!)
            .delete();
      } catch (e) {}
    }
    final imageUrl = await uploadTask.snapshot.ref.getDownloadURL();
    return await FirebaseAuth.instance.currentUser!.updatePhotoURL(imageUrl);
  }
}
