import 'package:flutter/material.dart';

/// Reusable Text Field Component
class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final bool isPassword;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.label,
    this.isPassword = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(labelText: label),
      obscureText: isPassword,
    );
  }
}
