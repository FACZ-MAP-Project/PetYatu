import 'package:flutter/material.dart';

class Care extends StatelessWidget {
  const Care({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: _appBar(), body: const Center(child: Text('Care')));
  }

  AppBar _appBar() {
    return AppBar(
      centerTitle: true,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
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
        ],
      ),
    );
  }
}