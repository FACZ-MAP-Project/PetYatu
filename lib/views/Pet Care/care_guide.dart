import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/article_provider.dart';
import '../../models/pet_article.dart';

class ViewArticles extends StatelessWidget {
  const ViewArticles({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ArticleProvider articleProvider =
        Provider.of<ArticleProvider>(context, listen: true);

    // Retrieve the list of articles
    final Future<List<Article>> articlesFuture =
        articleProvider.getAllArticles();

    return FutureBuilder<List<Article>>(
      future: articlesFuture,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Text('Something went wrong: ${snapshot.error}'),
          );
        }

        if (snapshot.connectionState == ConnectionState.done) {
          if (!snapshot.hasData) {
            return const Center(
              child: Text('No articles found.'),
            );
          }

          final List<Article> articles = snapshot.data!;

          return Scaffold(
            appBar: AppBar(
              title: const Text('Articles'),
            ),
            body: ListView.builder(
              itemCount: articles.length,
              itemBuilder: (context, index) {
                final Article article = articles[index];
                return Card(
                  child: Column(
                    children: [
                      if (article.imageUrl != null)
                        Image.network(article.imageUrl!),
                      ListTile(
                        title: Text(article.title),
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            '/view-article',
                            arguments: article,
                          );
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
          );
        }

        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}
