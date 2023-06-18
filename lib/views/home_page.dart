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
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
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
        ],
      ),
    );
  }

  TabBarView barView() {
    return const TabBarView(
      physics: NeverScrollableScrollPhysics(),
      children: [
        CatMoment(),
        SwipeCard(),
      ],
    );
  }
}
