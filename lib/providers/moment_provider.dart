import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';
import '../models/moment.dart';
import 'dart:io';

class MomentProvider with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // create moment
  Future<void> createMoment(
    Moment moment,
    File imageFile,
  ) async {
    // set moment.ownerId to current user's uid
    String fileName = const Uuid().v4();

    Reference reference = _storage.ref().child('moments').child(fileName);

    await reference.putFile(imageFile);

    String imageUrl = await reference.getDownloadURL();

    moment.image = imageUrl;
    moment.owner = _auth.currentUser!.uid;
    // set uid to document id
    moment.uid = _firestore.collection('moments').doc().id;

    try {
      await _firestore
          .collection('moments')
          .doc(moment.uid)
          .set(moment.toJson());
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  // view moments
  Future<List<Moment>> viewAllMoments() async {
    final List<Moment> _moments = [];

    try {
      final QuerySnapshot<Map<String, dynamic>> _querySnapshot =
          await _firestore
              .collection('moments')
              .orderBy('datePosted', descending: true)
              .get();

      for (var doc in _querySnapshot.docs) {
        _moments.add(Moment.fromJson(doc.data()));
      }
    } catch (e) {
      rethrow;
    }

    return _moments;
  }

  // delete moment
  Future<void> deleteMoment(String uid, String link) async {
    try {
      //delete image on storage
      await _storage.refFromURL(link).delete();
      await _firestore.collection('moments').doc(uid).delete();

      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  // update moment
  Future<void> updateMoment(Moment moment) async {
    try {
      await _firestore
          .collection('moments')
          .doc(moment.uid)
          .update(moment.toJson());
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  // like moment
  Future<void> likeMoment(String uid) async {
    try {
      await _firestore.collection('moments').doc(uid).update({
        'likes': FieldValue.increment(1),
        'likesBy':
            FieldValue.arrayUnion([_auth.currentUser!.uid]), // 'likesBy': 'uid
      });
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  // unlike moment
  Future<void> unlikeMoment(String uid) async {
    try {
      await _firestore.collection('moments').doc(uid).update({
        'likes': FieldValue.increment(-1),
        'likesBy': FieldValue.arrayRemove([_auth.currentUser!.uid]),
      });
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  // comment moment
  Future<void> commentMoment(String uid) async {
    try {
      await _firestore.collection('moments').doc(uid).update({
        'comments': FieldValue.increment(1),
        'commentsBy': FieldValue.arrayUnion([_auth.currentUser!.uid]),
      });
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  // uncomment moment
  Future<void> uncommentMoment(String uid) async {
    try {
      await _firestore.collection('moments').doc(uid).update({
        'comments': FieldValue.increment(-1),
        'commentsBy': FieldValue.arrayRemove([_auth.currentUser!.uid]),
      });
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> editDescription(String uid, String newDescription) async {
    try {
      await _firestore.collection('moments').doc(uid).update({
        'caption': newDescription,
      });
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }
}
