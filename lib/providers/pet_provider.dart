import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../models/pet.dart';
import 'package:uuid/uuid.dart';
import 'dart:io';

class PetProvider with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // create pet
  Future<void> createPet(Pet pet) async {
    // set pet.ownerId to current user's uid
    pet.owner = _auth.currentUser!.uid;
    // set uid to document id
    pet.uid = _firestore.collection('pets').doc().id;

    try {
      await _firestore.collection('pets').doc(pet.uid).set(pet.toJson());
      notifyListeners();
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
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  //upload pet image
  Future<String> uploadImage(
      File imageFile, String uid, String? oldImage) async {
    try {
      // Generate a unique filename using the uuid package
      String fileName = const Uuid().v4();
      Reference reference =
          _storage.ref().child('pets').child(uid).child(fileName);

      // Upload the file to Firebase Storage
      await reference.putFile(imageFile);

      // Delete the old image
      if (oldImage != "") {
        await _storage.refFromURL(oldImage!).delete();
      }

      // Get the download URL for the uploaded image
      String imageUrl = await reference.getDownloadURL();

      await _firestore.collection('pets').doc(uid).update({
        'image': imageUrl,
      });
      notifyListeners();
      return imageUrl;
    } catch (e) {
      // Handle any errors that occur during the upload process
      print('Error uploading image: $e');
      rethrow;
    }
  }

  // get pet
  Future<Pet> getPet(String uid) async {
    try {
      DocumentSnapshot<Map<String, dynamic>> documentSnapshot =
          await _firestore.collection('pets').doc(uid).get();

      return Pet.fromJson(documentSnapshot.data()!);
    } catch (e) {
      rethrow;
    }
  }

  Future<Pet> getPetByUuid(String petUuid) async {
    try {
      DocumentSnapshot<Map<String, dynamic>> documentSnapshot =
          await _firestore.collection('pets').doc(petUuid).get();

      return Pet.fromJson(documentSnapshot.data()!);
    } catch (e) {
      rethrow;
    }
  }

  // get pets for adoption
  Future<List<Pet>> getPetsForAdoption() async {
    final List<Pet> _pets = [];

    try {
      final QuerySnapshot<Map<String, dynamic>> _querySnapshot =
          await FirebaseFirestore.instance
              .collection('pets')
              .where('isOpenForAdoption', isEqualTo: true)
              .where("image", isNotEqualTo: "")
              .get();

      for (var doc in _querySnapshot.docs) {
        if (doc.data()['owner'] != _auth.currentUser!.uid) {
          _pets.add(Pet.fromJson(doc.data()));
        }
      }
    } catch (e) {
      rethrow;
    }

    return _pets;
  }
}
