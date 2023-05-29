import 'package:flutter/material.dart';
import 'dart:core';

class Care extends StatelessWidget {
  const Care({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: careView(),
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

  Widget careView() {
    return ListView(
      padding: const EdgeInsets.all(8),
      children: [
        Card(
          color: Colors.blue, // set color here
          child: Column(
            children: [
              SizedBox(
                height: 150, // set fixed height for image container
                width: double.infinity, // set width to fill available space
                child: Image.network(
                  'https://picsum.photos/id/1025/600/400',
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
        Card(
          color: Colors.green, // set color here
          child: Column(
            children: [
              SizedBox(
                height: 150, // set fixed height for image container
                width: double.infinity, // set width to fill available space
                child: Image.network(
                  'https://picsum.photos/id/1019/600/400',
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
        Card(
          color: Colors.orange, // set color here
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
                title: Text('Pet Adoption'),
                subtitle: Text('This is the section for pet adoption'),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
