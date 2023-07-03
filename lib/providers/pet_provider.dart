import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import '../models/pet.dart';
import 'package:uuid/uuid.dart';
import 'dart:io';
import 'package:permission_handler/permission_handler.dart';

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
      // await _firestore.collection('history')
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
      // if (oldImage != "") {
      //   await _storage.refFromURL(oldImage!).delete();
      // }

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

      if (documentSnapshot.exists) {
        Pet pet = Pet.fromJson(documentSnapshot.data()!);

        //separate location into latitude and longitude
        List<String> location = pet.location!.split(',');

        //get location name from latitude and longitude
        List<Placemark> locations = await placemarkFromCoordinates(
            double.parse(location[0]), double.parse(location[1]));

        pet.location =
            '${locations[0].locality}, ${locations[0].administrativeArea}';

        return pet;
      } else {
        return Pet.empty();
      }
    } catch (e) {
      rethrow;
    }
  }

// Get pets for adoption
  Future<List<Pet>> getPetsForAdoption() async {
    final List<Pet> _pets = [];
    LocationPermission permission;
    bool serviceEnabled;
    try {
      // Test if location services are enabled.
      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        // Check if location permission is granted
        PermissionStatus permissionStatus =
            await Permission.locationWhenInUse.status;
        if (!permissionStatus.isGranted) {
          if (await Permission.location.isPermanentlyDenied) {
            openAppSettings();
          } else {
            // If permission is not granted, request the permission
            Map<Permission, PermissionStatus> status =
                await [Permission.location].request();

            if (status[Permission.location] == PermissionStatus.denied) {
              // Permissions are denied, next time you could try
              // requesting permissions again (this is also where
              // Android's shouldShowRequestPermissionRationale
              // returned true. According to Android guidelines
              // your App should show an explanatory UI now.
              return Future.error('Location permissions are denied');
            }
          }
        }
      }

      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          // Permissions are denied, next time you could try
          // requesting permissions again (this is also where
          // Android's shouldShowRequestPermissionRationale
          // returned true. According to Android guidelines
          // your App should show an explanatory UI now.
          return Future.error('Location permissions are denied');
        }
      }

      if (permission == LocationPermission.deniedForever) {
        // Permissions are denied forever, handle appropriately.
        return Future.error(
            'Location permissions are permanently denied, we cannot request permissions.');
      }

      // When we reach here, permissions are granted and we can
      // continue accessing the position of the device.
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);

      String owner = _auth.currentUser!.uid;

      final QuerySnapshot<Map<String, dynamic>> _querySnapshot =
          await FirebaseFirestore.instance
              .collection('pets')
              .where('isOpenForAdoption', isEqualTo: true)
              .where("image", isNotEqualTo: "")
              .get();

      // Filter pets by distance (50km)
      // Location in the database is in the format String "latitude, longitude"
      // Then put how long from the user's location to the pet's location into a new variable as distance
      for (var doc in _querySnapshot.docs) {
        // if pet is owned by the user, skip it
        if (doc.data()['owner'] == owner) {
          continue;
        }

        // Separator is comma
        List<String> location = doc.data()['location'].split(',');
        double distance = Geolocator.distanceBetween(
            position.latitude,
            position.longitude,
            double.parse(location[0]),
            double.parse(location[1]));

        if (distance < 50000) {
          // Add distance value to the pet
          Pet pet = Pet.fromJson(doc.data());
          // Change to km and set two decimal points
          pet.distance = double.parse((distance / 1000).toStringAsFixed(2));
          _pets.add(pet);
        }
      }
    } catch (e) {
      rethrow;
    }

    return _pets;
  }

  // like a pet (increment like count and add user to likedBy list)
  Future<void> likePet(String petUuid) async {
    try {
      await _firestore.collection('pets').doc(petUuid).update({
        'likes': FieldValue.increment(1),
        'likedBy': FieldValue.arrayUnion([_auth.currentUser!.uid])
      });
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  //unlike a pet (decrement like count and remove user from likedBy list)
  Future<void> unlikePet(String petUuid) async {
    try {
      await _firestore.collection('pets').doc(petUuid).update({
        'likes': FieldValue.increment(-1),
        'likedBy': FieldValue.arrayRemove([_auth.currentUser!.uid])
      });
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  // check if pet is liked by user
  Future<bool> isLiked(String petUuid) async {
    try {
      DocumentSnapshot<Map<String, dynamic>> documentSnapshot =
          await _firestore.collection('pets').doc(petUuid).get();

      return documentSnapshot
          .data()!['likedBy']
          .contains(_auth.currentUser!.uid);
    } catch (e) {
      rethrow;
    }
  }
}
