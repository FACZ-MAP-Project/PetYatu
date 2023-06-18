import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Article {
  final String title;
  final String content;
  final String imageUrl;
  final String url;

  Article({
    required this.title,
    required this.content,
    required this.imageUrl,
    required this.url,
  });
}
