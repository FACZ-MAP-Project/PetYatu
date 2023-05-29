import 'package:flutter/material.dart';
import 'dart:core';
import 'veterinarystores_page.dart';

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
            Navigator.of(context).pushNamed('/');
          },
          child: Card(
            color: Colors.orange, // set color here
            child: Column(
              children: [
                SizedBox(
                  height: 150, // set fixed height for image container
                  width: double.infinity, // set width to fill available space
                  child: Image.network(
                    'https://picsum.photos/id/1026/600/400',
                    fit: BoxFit.cover,
                  ),
                ),
                const ListTile(
                  title: Text('First Aid'),
                  subtitle: Text('This is the section for first aid'),
                ),
              ],
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
            Navigator.of(context).pushNamed('/');
          },
          child: Card(
            color: Colors.green, // set color here
            child: Column(
              children: [
                SizedBox(
                  height: 150, // set fixed height for image container
                  width: double.infinity, // set width to fill available space
                  child: Image.network(
                    'https://picsum.photos/id/1028/600/400',
                    fit: BoxFit.cover,
                  ),
                ),
                const ListTile(
                  title: Text('Pet Care'),
                  subtitle: Text('This is the section for pet care'),
                ),
              ],
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
            Navigator.of(context).pushNamed('/manage-pets');
          },
          child: Card(
            color: Colors.blue, // set color here
            child: Column(
              children: [
                SizedBox(
                  height: 150, // set fixed height for image container
                  width: double.infinity, // set width to fill available space
                  child: Image.network(
                    'https://picsum.photos/id/1023/600/400',
                    fit: BoxFit.cover,
                  ),
                ),
                const ListTile(
                  title: Text('Manage Pets'),
                  subtitle: Text(
                      'This is the section for managing your pets and cat'),
                ),
              ],
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const Search()),
            );
          },
          child: Card(
            color: Colors.yellow, // set color here
            child: Column(
              children: [
                SizedBox(
                  height: 150, // set fixed height for image container
                  width: double.infinity, // set width to fill available space
                  child: Image.network(
                    'https://picsum.photos/id/1019/600/300',
                    fit: BoxFit.cover,
                  ),
                ),
                const ListTile(
                  title: Text('Veterinary Stores'),
                  subtitle: Text('This is the section for Veterinary Stores'),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
