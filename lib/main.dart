import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:petyatu/providers/moment_provider.dart';
import 'package:petyatu/views/add_moment.dart';
import 'package:petyatu/views/profile_cat_page.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'providers/auth_provider.dart';
import 'providers/user_provider.dart';
import 'providers/pet_provider.dart';

import 'package:petyatu/views/root_app.dart';
import 'package:petyatu/views/login_page.dart';
import 'views/Manage Pets/view_pet.dart';
import 'views/register_page.dart';
import 'views/forget_page.dart';
import 'views/Manage Pets/add_pet.dart';
import 'views/Manage Pets/manage_pets.dart';
import 'views/Pet Care/care_guide.dart';

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
        ChangeNotifierProvider<PetProvider>(
          create: (_) => PetProvider(),
        ),
        ChangeNotifierProvider<MomentProvider>(
          create: (_) => MomentProvider(),
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
        initialRoute: '/login',
        routes: {
          '/login': (context) => const LoginPage(),
          '/root': (context) => const RootApp(),
          '/add-pet': (context) => const AddPet(),
          '/manage-pets': (context) => const ManagePets(),
          '/register': (context) => const RegisterPage(),
          '/forget-password': (context) => const ForgetPasswordPage(),
          '/view-pet': (context) => const ViewPet(),
          '/adopt-me': (context) => const Profile(),
          '/pet-care': (context) => const Care(),
          '/add_moment': (context) => const AddMoment(),
        },
      ),
    );
  }
}
