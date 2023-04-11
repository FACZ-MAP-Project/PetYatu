import 'package:flutter/material.dart';
import 'package:petyatu/views/swipe_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    super.key,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<String> photoUrls = [
    'https://placekitten.com/200/300',
    'https://placekitten.com/202/300',
    'https://placekitten.com/207/300',
    'https://placekitten.com/204/300',
  ];

  final List<String> names = [
    'Kitty',
    'Tompok',
    'Melly',
    'Kapla',
  ];

  final List<String> descriptions = [
    "Healty and active",
    "Healty and active",
    "Healty and active",
    "Healty and active",
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      initialIndex: 1,
      child: Scaffold(appBar: appBar(), body: barView()),
    );
  }

  AppBar appBar() {
    return AppBar(
      centerTitle: true,
      title: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.asset('lib/assets/images/logo.png',
              fit: BoxFit.contain, height: 32),
        ),
        const Text('PetYatu',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 32,
            )),
      ]),
      bottom: const TabBar(
        tabs: <Widget>[
          Tab(
            text: 'Cats',
          ),
          Tab(
            text: 'Nearby',
          ),
          Tab(
            text: 'Favorites',
          ),
        ],
      ),
    );
  }

  TabBarView barView() {
    return TabBarView(
      children: [
        Center(child: Text('Cats')),
        SwipeCard(
            photoUrls: photoUrls, names: names, descriptions: descriptions),
        Center(child: Text('Favorites')),
      ],
    );
  }
}
