import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import '../models/history.dart';

class HistoryProvider with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  //history (user added pet)
  Future<void> historyAddPet(History history) async {
    // set history.ownerId to current user's uid
    history.user = _auth.currentUser!.uid;
    // set uid to document id
    history.uid = _firestore.collection('history').doc().id;

    try {
      await _firestore
          .collection('history')
          .doc(history.uid)
          .set(history.toJson());
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }
}
