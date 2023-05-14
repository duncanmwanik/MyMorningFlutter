import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:mymorning/services/local_storage_service.dart';

import '../../../screens/auth/permissions_screen.dart';
import '../../../widgets/loading_circle.dart';
import '../../../widgets/toast.dart';
import '../global_helper.dart';

Future<FirebaseApp> initializeFirebase() async {
  FirebaseApp firebaseApp = await Firebase.initializeApp();
  return firebaseApp;
}

//---------- Signup
Future<void> registerUsingEmailPassword(
  BuildContext context, {
  required String name,
  required String email,
  required String password,
}) async {
  FirebaseAuth auth = FirebaseAuth.instance;
  User? user;
  try {
    showLoadingCircle(context);

    UserCredential userCredential = await auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    user = userCredential.user;
    await user!.updateDisplayName(name);
    await user.reload();
    user = auth.currentUser;

    if (user != null) {
      removeLoadingCircle(context);
      toast(1, "Sign Up successful!");

      Navigator.pushAndRemoveUntil<dynamic>(
        context,
        MaterialPageRoute<dynamic>(
          builder: (BuildContext context) => PermissionsScreen(),
        ),
        (route) => false,
      );
    }
  } on FirebaseAuthException catch (e) {
    removeLoadingCircle(context);

    if (e.code == 'weak-password') {
      toast(0, 'The password provided is too weak.');
    } else if (e.code == 'email-already-in-use') {
      toast(2, 'An account already exists for that email.');
    }
  } catch (e) {
    print(e);
  }
}

//---------- Login
Future<void> signInUsingEmailPassword(
  BuildContext context, {
  required String email,
  required String password,
}) async {
  FirebaseAuth auth = FirebaseAuth.instance;
  User? user;

  try {
    showLoadingCircle(context);

    UserCredential userCredential = await auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    user = userCredential.user;

    if (user != null) {
      removeLoadingCircle(context);
      toast(1, "Sign In successful!");

      Navigator.pushAndRemoveUntil<dynamic>(
        context,
        MaterialPageRoute<dynamic>(
          builder: (BuildContext context) => PermissionsScreen(),
        ),
        (route) => false,
      );
    }
  } on FirebaseAuthException catch (e) {
    removeLoadingCircle(context);

    if (e.code == 'user-not-found') {
      toast(0, 'No user found for that email.');
    } else if (e.code == 'wrong-password') {
      toast(0, 'Wrong password.');
    }
  }
}

Future<bool> getUserStatusFromFirebaseAuth() async {
  await Firebase.initializeApp();
  User? user = FirebaseAuth.instance.currentUser;
  bool isFirstTimeUser = false;

  if (user == null) {
    print("User is not signed in!");
    isFirstTimeUser = prefs.getBool("isFirstTimeUser") ?? true;
  } else {
    print(user.email);
    print(user.displayName);
  }

  return isFirstTimeUser;
}
