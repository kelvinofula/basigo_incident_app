import 'package:flutter/material.dart';
import 'welcome_header.dart';
import 'welcome_button.dart';

/// Welcome Screen allowing users to log in as a driver or dispatcher
class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const WelcomeHeader(),
            const SizedBox(height: 44),
            const WelcomeButton(
              userRole: 'Driver',
              backgroundColor: Colors.black,
              textColor: Colors.white,
            ),
            const SizedBox(height: 20),
            const WelcomeButton(
              userRole: 'Dispatcher',
              backgroundColor: Color.fromARGB(255, 79, 251, 85),
              textColor: Colors.black,
            ),
          ],
        ),
      ),
      backgroundColor: Colors.white,
    );
  }
}
