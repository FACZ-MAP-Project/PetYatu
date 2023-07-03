import 'package:flutter/material.dart';
import 'package:petyatu/views/home_page.dart';
import 'package:petyatu/views/history_page.dart';
import 'package:petyatu/views/care_page.dart';
import 'package:petyatu/views/profile_person_page.dart';

class RootApp extends StatefulWidget {
  const RootApp({Key? key}) : super(key: key);

  @override
  RootAppState createState() => RootAppState();
}

class RootAppState extends State<RootApp> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _tabBody(),
      bottomNavigationBar: _bottomNavigationBar(),
    );
  }

  // AppBar _appBar() {
  //   return AppBar(
  //     centerTitle: true,
  //     title: Row(
  //       mainAxisAlignment: MainAxisAlignment.center,
  //       children: [
  //         Padding(
  //           padding: const EdgeInsets.all(8.0),
  //           child: Image.asset('lib/assets/images/logo.png',
  //               fit: BoxFit.contain, height: 32),
  //         ),
  //         const Text('PetYatu',
  //             style: TextStyle(
  //               color: Colors.black,
  //               fontWeight: FontWeight.bold,
  //               fontSize: 32,
  //             )),
  //       ],
  //     ),
  //   );
  // }

  IndexedStack _tabBody() {
    return IndexedStack(
      index: _selectedIndex,
      children: const [
        HomePage(),
        HistoryPage(),
        Care(),
        Profile(),
      ],
    );
  }

  BottomNavigationBar _bottomNavigationBar() {
    return BottomNavigationBar(
      currentIndex: _selectedIndex,
      selectedItemColor: Colors.black,
      unselectedItemColor: Colors.grey,
      onTap: _onItemTapped,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home_outlined),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.history_outlined),
          label: 'History',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.book_outlined),
          label: 'Care',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person_outlined),
          label: 'Profile',
        ),
      ],
    );
  }
}
