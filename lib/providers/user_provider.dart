import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/app_user.dart';

class UserProvider with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Get user info from Firestore
  Future<AppUser?> getUser(String uid) async {
    try {
      DocumentSnapshot documentSnapshot =
          await _firestore.collection('users').doc(uid).get();

      return AppUser.fromDocumentSnapshot(documentSnapshot);
    } catch (e) {
      rethrow;
    }
  }

  // Get user data from Firestore in the form of JSON and convert it to AppUser
  Future<AppUser?> getUserFromJson(String uid) async {
    try {
      DocumentSnapshot documentSnapshot =
          await _firestore.collection('users').doc(uid).get();

      return AppUser.fromJson(documentSnapshot.data()! as Map<String, dynamic>);
    } catch (e) {
      rethrow;
    }
  }

  // Update user profile in Firestore
  Future<void> updateUser(AppUser updatedUser) async {
    try {
      await _firestore
          .collection('users')
          .doc(updatedUser.uid)
          .update(updatedUser.toMap());
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }
}
