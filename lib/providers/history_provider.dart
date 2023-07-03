import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:petyatu/models/pet.dart';
import '../models/history.dart';

class HistoryProvider with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  //history (user added pet)
  Future<void> historyAddPet(Pet pet) async {
    // set history.ownerId to current user's uid
    History history = History(
      uid: _firestore.collection('history').doc().id,
      user: _auth.currentUser!.uid,
      sentence: 'You added a pet: ${pet.name}',
      pet: pet.uid,
      otherUser: '',
      image: '',
      dateCreated: DateTime.now(),
    );

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
