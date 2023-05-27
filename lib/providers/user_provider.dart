import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/app_user.dart';

class UserProvider with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // get user info from firestore
  Future<AppUser?> getUser(String uid) async {
    try {
      DocumentSnapshot documentSnapshot =
          await _firestore.collection('users').doc(uid).get();
      return AppUser.fromDocumentSnapshot(documentSnapshot);
    } catch (e) {
      rethrow;
    }
  }
}
