import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import '../../ui/screens/intro/permissions/permissions_screen.dart';
import '../../ui/widgets/toast.dart';

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
    UserCredential userCredential = await auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    user = userCredential.user;
    await user!.updateDisplayName(name);
    await user.reload();
    user = auth.currentUser;

    if (user != null) {
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
    if (e.code == 'weak-password') {
      toast(0, 'The password provided is too weak!');
    } else if (e.code == 'email-already-in-use') {
      toast(2, 'The account already exists for that email!');
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
    UserCredential userCredential = await auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    user = userCredential.user;

    if (user != null) {
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
    if (e.code == 'user-not-found') {
      toast(0, 'No user found for that email.');
    } else if (e.code == 'wrong-password') {
      toast(0, 'Wrong password provided!');
    }
  }
}

Future<bool> getUserStatusFromFirebaseAuth() async {
  await Firebase.initializeApp();
  User? user = FirebaseAuth.instance.currentUser;
  if (user != null) {
    print(user.email);
    print(user.displayName);
  } else {
    print("User is not signed in!");
  }

  return user != null;
}
