import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:petyatu/providers/auth_provider.dart';
import 'package:petyatu/models/AppUser.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // final _formKey = GlobalKey<FormState>();

  // String _email = '';
  // String _password = '';

  // bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Email',
              ),
            ),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(
                labelText: 'Password',
              ),
              obscureText: true,
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () => _login(authProvider),
              child: Text('Login'),
            ),
            SizedBox(height: 16.0),
            TextButton(
              onPressed: () {
                Navigator.of(context).pushReplacementNamed('/register');
              },
              child: Text('Create an account'),
            ),
          ],
        ),
      ),
    );
  }

  void _login(AuthProvider authProvider) async {
    AppUser user = AppUser(
      uid: '',
      name: '',
      email: _emailController.text,
      password: _passwordController.text,
      token: '',
    );

    // if (_formKey.currentState!.validate()) {
    //   setState(() {
    //     _isLoading = true;
    //   });

    try {
      await authProvider.loginUser(user);

      // Navigate to home page
      Navigator.pushNamedAndRemoveUntil(
        context,
        '/root',
        (route) => false,
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('No user found for that email.'),
          ),
        );
      } else if (e.code == 'wrong-password') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Wrong password provided for that user.'),
          ),
        );
      }
    } finally {
      // setState(() {
      //   _isLoading = false;
      // });
    }
  }
}
