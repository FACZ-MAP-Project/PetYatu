import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../models/pet_article.dart';

class ViewArticleScreen extends StatelessWidget {
  const ViewArticleScreen({Key? key, required this.article}) : super(key: key);

  final Article article;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(article.title),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                article.title,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                article.content,
                style: const TextStyle(
                  fontSize: 16,
                ),
              ),
            ),
            // ignore: unnecessary_null_comparison
            if (article.url != null)
              ElevatedButton(
                onPressed: () {
                  launch(article.url!);
                },
                child: const Text('Open URL'),
              ),
          ],
        ),
      ),
    );
  }
}
