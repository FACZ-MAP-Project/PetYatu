import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/app_user.dart';
import '../models/pet.dart';

class PetProvider with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // create pet
  Future<void> createPet(Pet pet) async {
    // set pet.ownerId to current user's uid
    pet.owner = _auth.currentUser!.uid;
    // set uid to document id
    pet.uid = _firestore.collection('pets').doc().id;

    try {
      await _firestore.collection('pets').doc(pet.uid).set(pet.toJson());
    } catch (e) {
      rethrow;
    }
  }

  // view my pets
  Future<List<Pet>> viewMyPets() async {
    final List<Pet> _pets = [];

    try {
      final QuerySnapshot<Map<String, dynamic>> _querySnapshot =
          await _firestore
              .collection('pets')
              .where('owner', isEqualTo: _auth.currentUser!.uid)
              .get();

      for (var doc in _querySnapshot.docs) {
        _pets.add(Pet.fromJson(doc.data()));
      }
    } catch (e) {
      rethrow;
    }

    return _pets;
  }

  // delete pet
  Future<void> deletePet(String uid) async {
    try {
      await _firestore.collection('pets').doc(uid).delete();
    } catch (e) {
      rethrow;
    }
  }
}
