import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/app_user.dart';

class AuthProvider with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // login user with email and password
  Future<void> loginUser(AppUser appUser) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
        email: appUser.email,
        password: appUser.password,
      );
    } catch (e) {
      rethrow;
    }
  }

  // register user with email and password
  Future<void> registerUser(AppUser appUser) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: appUser.email,
        password: appUser.password,
      );

      // AppUser? firebaseUser = result.user as AppUser?;
      AppUser? firebaseUser =
          result.user != null ? AppUser.withId(result.user!.uid) : null;
      if (firebaseUser != null) {
        // save user info to firestore
        await _firestore.collection('users').doc(firebaseUser.uid).set(
          {
            'uid': firebaseUser.uid,
            'name': appUser.name,
            'email': appUser.email,
            'password': appUser.password,
            'token': appUser.token,
          },
        );
      }
    } catch (e) {
      rethrow;
    }
  }
}
