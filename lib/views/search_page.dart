import 'package:flutter/material.dart';
import 'pet_store_details_page.dart'; // Import the pet store details page

class Search extends StatelessWidget {
  const Search({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: vetStores(context), // Pass the context to vetStores method
    );
  }

  AppBar _appBar() {
    return AppBar(
      centerTitle: true,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.asset(
                'lib/assets/images/logo.png',
                fit: BoxFit.contain,
                height: 32,
                alignment: Alignment.topRight,
              ),
            ),
          ),
          const Expanded(
            child: Text(
              'PetYatu',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 32,
              ),
            ),
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: Icon(Icons.search),
          onPressed: () {
            // Handle search button pressed
            // Perform search operation
          },
        ),
      ],
    );
  }

  Widget vetStores(BuildContext context) {
    // Accept the context parameter
    return ListView(
      padding: const EdgeInsets.all(8),
      children: [
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => PetStoreDetailsPage()),
            );
          },
          child: Card(
            color: Colors.blue,
            child: Column(
              children: [
                SizedBox(
                  height: 150,
                  width: double.infinity,
                  child: Image.network(
                    'https://picsum.photos/id/1025/600/400',
                    fit: BoxFit.cover,
                  ),
                ),
                ListTile(
                  title: Text('Pet Store 1'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Address: 123 Street'),
                      Text('Opening Hours: 9:00 AM - 6:00 PM'),
                      Text('Distance: 1.5 miles'),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => PetStoreDetailsPage()),
            );
          },
          child: Card(
            color: Colors.yellow,
            child: Column(
              children: [
                SizedBox(
                  height: 150,
                  width: double.infinity,
                  child: Image.network(
                    'https://picsum.photos/id/1019/600/400',
                    fit: BoxFit.cover,
                  ),
                ),
                ListTile(
                  title: Text('Pet Store 2'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Address: 456 Avenue'),
                      Text('Opening Hours: 8:00 AM - 7:00 PM'),
                      Text('Distance: 2.2 miles'),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => PetStoreDetailsPage()),
            );
          },
          child: Card(
            color: Colors.lightGreen,
            child: Column(
              children: [
                SizedBox(
                  height: 150,
                  width: double.infinity,
                  child: Image.network(
                    'https://picsum.photos/id/1023/600/400',
                    fit: BoxFit.cover,
                  ),
                ),
                ListTile(
                  title: Text('Pet Store 3'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Address: 789 Road'),
                      Text('Opening Hours: 9:30 AM - 5:30 PM'),
                      Text('Distance: 0.8 miles'),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
