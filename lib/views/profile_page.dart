import 'package:flutter/material.dart';

class Profile extends StatelessWidget {
  const Profile({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.black),
        title: const Text("Adopt Me", style: TextStyle(color: Colors.black)),
      ),
      body: const Center(
        child: Text("Adopt Me"),
      ),
    );
  }
}
