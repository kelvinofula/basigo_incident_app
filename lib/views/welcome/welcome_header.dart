import 'package:flutter/material.dart';

/// Header widget containing the app logo and title
class WelcomeHeader extends StatelessWidget {
  const WelcomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Center(child: Image.asset('assets/images/app_logo.png', height: 120)),
        const SizedBox(height: 72),
        const Text(
          'Welcome to Dispatch & Incident Reporting',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
