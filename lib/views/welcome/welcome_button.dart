import 'package:flutter/material.dart';
import '../login_form.dart';

/// Reusable login button for Driver & Dispatcher
class WelcomeButton extends StatelessWidget {
  final String userRole;
  final Color backgroundColor;
  final Color textColor;

  const WelcomeButton({
    super.key,
    required this.userRole,
    required this.backgroundColor,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(26)),
        backgroundColor: backgroundColor,
      ),
      onPressed:
          () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => LoginForm(userRole: userRole)),
          ),
      child: Text(
        'Login as $userRole',
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: textColor,
        ),
      ),
    );
  }
}
