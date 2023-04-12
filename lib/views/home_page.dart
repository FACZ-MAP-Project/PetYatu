import 'package:flutter/material.dart';
import 'package:petyatu/views/swipe_card.dart';
import 'package:petyatu/views/favorites_page.dart';
import 'package:petyatu/views/moment_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    super.key,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<String> photoUrls = [
    'https://placekitten.com/200/300',
    'https://placekitten.com/202/300',
    'https://placekitten.com/207/300',
    'https://placekitten.com/204/300',
    'https://cdn.pixabay.com/photo/2015/02/25/17/56/cat-649164__340.jpg',
    'https://cdn.pixabay.com/photo/2014/11/30/14/11/kitty-551554__340.jpg',
    'https://placekitten.com/198/300',
    'https://placekitten.com/209/300',
    'https://cdn.pixabay.com/photo/2016/09/05/21/37/cat-1647775__340.jpg',
    'https://cdn.pixabay.com/photo/2016/01/20/13/05/cat-1151519__340.jpg',
    'https://placekitten.com/197/300',
    'https://placekitten.com/165/300',
    'https://cdn.pixabay.com/photo/2014/04/13/20/49/cat-323262__340.jpg',
    'https://placekitten.com/300/300',
    'https://placekitten.com/400/300',
    'https://placekitten.com/520/300',
    'https://cdn.pixabay.com/photo/2014/11/30/14/11/kitty-551554__340.jpg',
  ];

  List<String> names = [
    'Kitty',
    'Tompok',
    'Melly',
    'Kapla',
    'Mittens',
    'Whiskers',
    'Fluffy',
    'Snowball',
    'Boots',
    'Shadow',
    'Simba',
    'Garfield',
    'Socks',
    'Marmalade',
    'Luna',
    'Oreo',
    'Felix'
  ];

  List<String> descriptions = [
    'Kitty is a calico cat who loves to cuddle.',
    'Tompok is a gray tabby who is very playful.',
    'Melly is a black and white tuxedo cat who is very curious.',
    'Kapla is a Siamese cat who is very vocal.',
    'Mittens is a white cat with black paws who loves to nap.',
    'Whiskers is a brown tabby who loves to play with toys.',
    'Fluffy is a long-haired cat who is very soft and cuddly.',
    'Snowball is a white cat who loves to play in the snow.',
    'Boots is a black cat with white paws who is very fast.',
    'Shadow is a black cat who is very mysterious.',
    'Simba is an orange tabby who loves to sunbathe.',
    'Garfield is a ginger cat who loves to eat lasagna.',
    'Socks is a gray and white cat who loves to nap in socks.',
    'Marmalade is an orange cat who loves to explore.',
    'Luna is a black cat who loves to howl at the moon.',
    'Oreo is a black and white cat who loves to play hide and seek.',
    'Felix is a black and white cartoon cat who loves to get into mischief.'
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
      physics: const NeverScrollableScrollPhysics(),
      children: [
        CatMoment(),
        SwipeCard(
            photoUrls: photoUrls, names: names, descriptions: descriptions),
        Favorites(),
      ],
    );
  }
}
