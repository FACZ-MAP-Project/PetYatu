import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../models/pet_article.dart';

class ArticleProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

//get data from firestore
  Future<List<Article>> getArticles() async {
    List<Article> articles = [];
    try {
      await _firestore.collection('articles').get().then((querySnapshot) {
        for (var element in querySnapshot.docs) {
          articles.add(Article.fromJson(element.data()));
        }
      });
      return articles;
    } catch (e) {
      rethrow;
    }
  }

//get article by title
  Future<Article> getArticleByTitle(String title) async {
    try {
      final DocumentSnapshot<Map<String, dynamic>> documentSnapshot =
          await _firestore.collection('articles').doc(title).get();

      return Article.fromJson(documentSnapshot.data()!);
    } catch (e) {
      rethrow;
    }
  }

  //get all articles
  Future<List<Article>> getAllArticles() async {
    List<Article> articles = [];
    try {
      await _firestore.collection('articles').get().then((querySnapshot) {
        for (var element in querySnapshot.docs) {
          articles.add(Article.fromJson(element.data()));
        }
      });
      return articles;
    } catch (e) {
      rethrow;
    }
  }

  //add article
  Future<void> addArticle(Article article) async {
    try {
      await _firestore
          .collection('articles')
          .doc(article.title)
          .set(article.toJson());
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }
}
