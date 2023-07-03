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
      type: 'MY_PET',
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

  //history (user upload pet image)
  Future<void> historyPetImage(Pet pet, String imageUrl) async {
    // set history.ownerId to current user's uid
    History history = History(
      uid: _firestore.collection('history').doc().id,
      type: 'MY_PET',
      user: _auth.currentUser!.uid,
      sentence: 'You added an image for pet: ${pet.name}',
      pet: pet.uid,
      otherUser: '',
      image: imageUrl,
      dateCreated: DateTime.now(),
    );

    try {
      await _firestore
          .collection('history')
          .doc(history.uid)
          .set(history.toJson());
      // find all history with pet.uid and change image to imageUrl
      final QuerySnapshot<Map<String, dynamic>> _querySnapshot =
          await _firestore
              .collection('history')
              .where('pet', isEqualTo: pet.uid)
              .get();

      // loop through all history with pet.uid and change image to imageUrl
      for (var doc in _querySnapshot.docs) {
        await _firestore
            .collection('history')
            .doc(doc.id)
            .update({'image': imageUrl});
      }
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> historyDeletePet(Pet pet) async {
    // set history.ownerId to current user's uid
    History history = History(
      uid: _firestore.collection('history').doc().id,
      type: 'DELETED',
      user: _auth.currentUser!.uid,
      sentence: 'You deleted a pet: ${pet.name}',
      pet: pet.uid,
      otherUser: '',
      image: pet.image ?? '',
      dateCreated: DateTime.now(),
    );

    try {
      await _firestore
          .collection('history')
          .doc(history.uid)
          .set(history.toJson());
      // find all history with pet.uid and change type to DELETED
      final QuerySnapshot<Map<String, dynamic>> _querySnapshot =
          await _firestore
              .collection('history')
              .where('pet', isEqualTo: pet.uid)
              .get();
      // loop through all history with pet.uid and change type to DELETED
      for (var doc in _querySnapshot.docs) {
        await _firestore
            .collection('history')
            .doc(doc.id)
            .update({'type': 'DELETED'});
      }
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  Future<List<History>> viewMyHistory() async {
    final List<History> _history = [];

    try {
      final QuerySnapshot<Map<String, dynamic>> _querySnapshot =
          await _firestore
              .collection('history')
              .where('user', isEqualTo: _auth.currentUser!.uid)
              .get();

      for (var doc in _querySnapshot.docs) {
        _history.add(History.fromJson(doc.data()));
      }
    } catch (e) {
      rethrow;
    }

    return _history;
  }
}
