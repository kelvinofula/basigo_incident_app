import 'package:flutter/material.dart';

/// EmptyState - Displays when there are no incidents reported
class EmptyState extends StatelessWidget {
  const EmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 80.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: Image.asset('assets/images/incident_icon.png', height: 150),
          ),
          const SizedBox(height: 24),
          const Center(
            child: Text(
              'No incidents reported yet.',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
