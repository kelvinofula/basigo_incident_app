import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dispatcher_home_page.dart';
import 'driver_home_page.dart';
import '../components/custom_text_field.dart';
import '../components/primary_button.dart';

/// Login Form
class LoginForm extends StatefulWidget {
  final String userRole;
  const LoginForm({super.key, required this.userRole});

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _isLoading = false;

  void _login() async {
    setState(() => _isLoading = true);

    //final box = await Hive.openBox('credentials'); // Open box
    final username = _usernameController.text;
    final password = _passwordController.text;

    if (username == 'Driver' && password == 'driver123') {
      await _authenticateUser('driver@email.com', 'driver123', 'Driver');
    } else if (username == 'Dispatcher' && password == 'dispatcher123') {
      await _authenticateUser(
        'dispatcher@email.com',
        'dispatcher123',
        'Dispatcher',
      );
    } else {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invalid credentials! Please try again.')),
      );
    }
  }

  Future<void> _authenticateUser(
    String email,
    String password,
    String role,
  ) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      await Hive.box('credentials').put('loggedInUser', role);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder:
              (_) =>
                  role == 'Driver'
                      ? const DriverHomePage()
                      : const DispatcherHomePage(),
        ),
      );
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Authentication failed: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login as ${widget.userRole}'),
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 32),
              Center(
                child: Image.asset('assets/images/go_logo.png', height: 120),
              ),
              const SizedBox(height: 32),
              CustomTextField(
                controller: _usernameController,
                label: 'Username',
              ),
              const SizedBox(height: 24),
              CustomTextField(
                controller: _passwordController,
                label: 'Password',
                isPassword: true,
              ),
              const SizedBox(height: 56),
              _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : PrimaryButton(
                    text: 'Login',
                    onPressed: _login,
                    backgroundColor: Colors.black,
                    textColor: Colors.white,
                  ),
            ],
          ),
        ),
      ),
      backgroundColor: Colors.white,
    );
  }
}
