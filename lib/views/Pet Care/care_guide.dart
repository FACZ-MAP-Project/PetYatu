import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class Care extends StatelessWidget {
  const Care({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: careView(context),
    );
  }

  AppBar _appBar() {
    return AppBar(
      centerTitle: true,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset(
              'lib/assets/images/logo.png',
              fit: BoxFit.contain,
              height: 32,
            ),
          ),
          const Text(
            'PetYatu',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 32,
            ),
          ),
        ],
      ),
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
                  imageUrl: 'https://picsum.photos/id/1020/600/400',
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
                    'https://picsum.photos/id/1020/600/400',
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
      ],
    );
  }
}

class ArticlePage extends StatelessWidget {
  final String title;
  final String content;
  final String imageUrl;
  final String url;

  const ArticlePage({
    required this.title,
    required this.content,
    required this.imageUrl,
    required this.url,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 200,
              width: double.infinity,
              child: Image.network(
                imageUrl,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                content,
                style: const TextStyle(fontSize: 18),
              ),
            ),
            GestureDetector(
              onTap: () {
                launchURL(url);
              },
              child: Container(
                width: double.infinity,
                color: Colors.blue,
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(
                      Icons.open_in_browser,
                      color: Colors.white,
                    ),
                    SizedBox(width: 8),
                    Text(
                      'Read More',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void launchURL(String url) async {
    // ignore: deprecated_member_use
    if (await canLaunch(url)) {
      // ignore: deprecated_member_use
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
