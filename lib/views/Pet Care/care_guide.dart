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

  Widget careView(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(8),
      children: [
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const ArticlePage(
                  title: 'Pet Grooming',
                  content:
                      'Grooming pets is an important part of animal care. Most animals can be taught to enjoy grooming at any age. Regular pet grooming will help you build and maintain healthy relationships with your pets, and practice gentle leadership skills. Another benefit of grooming is that you may notice a physical change that needs medical attention, something that might not have been obvious if you hadn’t been grooming your pet. If you find any lumps, bumps or soreness, schedule an appointment with your veterinarian for a checkup.',
                  imageUrl:
                      'https://media.istockphoto.com/id/1448078058/photo/sleeping-cat.jpg?s=1024x1024&w=is&k=20&c=_yAq163GCFYSjpbJom8Ow2IRIvlssZ7zaPtFMq4MSLE=',
                  url:
                      'https://resources.bestfriends.org/article/pet-grooming-tips',
                ),
              ),
            );
          },
          child: Card(
            color: Colors.orange,
            child: Column(
              children: [
                SizedBox(
                  height: 150,
                  width: double.infinity,
                  child: Image.network(
                    'https://media.istockphoto.com/id/1448078058/photo/sleeping-cat.jpg?s=1024x1024&w=is&k=20&c=_yAq163GCFYSjpbJom8Ow2IRIvlssZ7zaPtFMq4MSLE=',
                    fit: BoxFit.cover,
                  ),
                ),
                const ListTile(
                  title: Text('Pet Grooming'),
                  subtitle: Text('This is the section for pet grooming'),
                ),
              ],
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const ArticlePage(
                  title: 'Pet Feeding Times',
                  content:
                      'Cats that are confined indoors are dependent on their owners to determine when, what and how they eat, which impacts a cat’s welfare on multiple levels. Obesity and behavior problems are common in pet cats1–3, and these conditions, although multifactorial, may be related to the ways that cats are fed1,4,5',
                  imageUrl:
                      'https://cdn.pixabay.com/photo/2017/07/25/01/22/cat-2536662_1280.jpg',
                  url: 'https://www.ncbi.nlm.nih.gov/pmc/articles/PMC7415653/',
                ),
              ),
            );
          },
          child: Card(
            color: Colors.orange,
            child: Column(
              children: [
                SizedBox(
                  height: 150,
                  width: double.infinity,
                  child: Image.network(
                    'https://cdn.pixabay.com/photo/2017/07/25/01/22/cat-2536662_1280.jpg',
                    fit: BoxFit.cover,
                  ),
                ),
                const ListTile(
                  title: Text('Pet Feeding Times'),
                  subtitle: Text('This is the section for pet feeding'),
                ),
              ],
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const ArticlePage(
                  title: 'Pet Health',
                  content:
                      'Play is a very important part of the feline world and kittens need the opportunity to play in order to learn vital adult skills both for communication and for hunting. From a very early age, they play with their littermates and with objects that they find in their environment.',
                  imageUrl:
                      'https://media.istockphoto.com/id/943662896/photo/gray-striped-cat-lying-in-the-room.jpg?s=612x612&w=is&k=20&c=bTlKK5NEFSR1g2oOy0OqGPPuLql-VoeFvNSFyW9Z6BY=',
                  url:
                      'https://vcahospitals.com/know-your-pet/kitten-behavior-and-training-play-and-investigative-behaviors',
                ),
              ),
            );
          },
          child: Card(
            color: Colors.orange,
            child: Column(
              children: [
                SizedBox(
                  height: 150,
                  width: double.infinity,
                  child: Image.network(
                    'https://media.istockphoto.com/id/943662896/photo/gray-striped-cat-lying-in-the-room.jpg?s=612x612&w=is&k=20&c=bTlKK5NEFSR1g2oOy0OqGPPuLql-VoeFvNSFyW9Z6BY=',
                    fit: BoxFit.cover,
                  ),
                ),
                const ListTile(
                  title: Text('Pet Behavior and Training'),
                  subtitle:
                      Text('This is the section for pet Behavior and Training'),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
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
