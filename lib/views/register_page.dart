import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:petyatu/providers/auth_provider.dart';
import 'package:petyatu/models/AppUser.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  static const routeName = '/register';

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _registerUser(AuthProvider authProvider) async {
    AppUser user = AppUser(
      uid: '',
      name: _nameController.text,
      email: _emailController.text,
      password: _passwordController.text,
      token: '',
    );

    try {
      await authProvider.registerUser(user);
      // go to login page
      Navigator.of(context).pushReplacementNamed('/login');
      // Registration successful, navigate to the next screen or perform other actions
    } catch (error) {
      if (error.toString().contains('email-already-in-use')) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Email already in use'),
          ),
        );
      } else if (error.toString().contains('invalid-email')) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Invalid email'),
          ),
        );
      } else if (error.toString().contains('weak-password')) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Weak password'),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Registration failed'),
          ),
        );
      }
      // Handle registration error
    }
  }

  @override
  Widget build(BuildContext context) {
    final AuthProvider authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Registration'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Name',
              ),
            ),
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
              onPressed: () => _registerUser(authProvider),
              child: Text('Register'),
            ),
            SizedBox(height: 16.0),
            TextButton(
              onPressed: () {
                Navigator.of(context).pushReplacementNamed('/login');
              },
              child: Text('Login'),
            ),
          ],
        ),
      ),
    );
  }
}
