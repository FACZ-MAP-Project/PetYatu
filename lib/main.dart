import 'package:flutter/material.dart';
import 'package:petyatu/views/root_app.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color(0xFFFFB6C1),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFFFB6C1),
        ),
      ),
      title: 'PetYatu',
      home: const RootApp(),
    );
  }
}
