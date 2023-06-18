import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../models/pet_article.dart';

class ArticleProvider extends ChangeNotifier {
  List<Article> _articles = [];

  List<Article> get articles => _articles;

  Future<void> fetchArticles() async {
    final snapshot =
        await FirebaseFirestore.instance.collection('articles').get();
    final articles = snapshot.docs.map((doc) {
      // ignore: unnecessary_cast
      final data = doc.data() as Map<String, dynamic>;
      return Article(
        title: data['title'],
        content: data['content'],
        imageUrl: data['imageUrl'],
        url: data['url'],
      );
    }).toList();

    _articles = articles;
    notifyListeners();
  }
}
