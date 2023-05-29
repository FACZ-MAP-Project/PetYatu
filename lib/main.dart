import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'providers/auth_provider.dart';
import 'providers/user_provider.dart';

import 'package:petyatu/views/root_app.dart';
import 'package:petyatu/views/login_page.dart';
import 'views/register_page.dart';
import 'views/forget_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthProvider>(
          create: (_) => AuthProvider(),
        ),
        ChangeNotifierProvider<UserProvider>(
          create: (_) => UserProvider(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: const Color(0xFFFFB6C1),
          appBarTheme: const AppBarTheme(
            backgroundColor: Color(0xFFFFB6C1),
          ),
        ),
        title: 'PetYatu',
        home: const RootApp(),
        initialRoute: '/login',
        routes: {
          '/login': (context) => const LoginPage(),
          '/root': (context) => const RootApp(),
          '/register': (context) => const RegisterPage(),
          '/forget-password': (context) => const ForgetPasswordPage(),
        },
      ),
    );
  }
}
