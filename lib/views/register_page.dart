import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:petyatu/providers/auth_provider.dart';
import 'package:petyatu/models/app_user.dart';

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
    AppUser user = AppUser.register(
      uid: '',
      name: _nameController.text,
      email: _emailController.text,
      password: _passwordController.text,
      token: '',
      dateJoined: DateTime.now(),
    );

    try {
      await authProvider.registerUser(user);
      // go to login page
      // ignore: use_build_context_synchronously
      Navigator.of(context).pushReplacementNamed('/login');
      // Registration successful, navigate to the next screen or perform other actions
    } catch (error) {
      if (error.toString().contains('email-already-in-use')) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Email already in use'),
          ),
        );
      } else if (error.toString().contains('invalid-email')) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Invalid email'),
          ),
        );
      } else if (error.toString().contains('weak-password')) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Weak password'),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
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
        title: const Text('Registration'),
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const Image(
                  image: AssetImage('lib/assets/images/logo.png'), height: 200),
              const Text(
                'PetYatu',
                style: TextStyle(
                  fontSize: 32.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Name',
                ),
              ),
              TextField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                ),
              ),
              TextField(
                controller: _passwordController,
                decoration: const InputDecoration(
                  labelText: 'Password',
                ),
                obscureText: true,
              ),
              const SizedBox(height: 16.0),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    _registerUser(authProvider);
                  },
                  child: const Text('Register'),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pushReplacementNamed('/login');
                },
                child: const Text('Have an account? Login'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
