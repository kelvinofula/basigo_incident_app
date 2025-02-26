import 'package:flutter/material.dart';
import '../models/incident_model.dart';

/// IncidentCard - Displays an incident with title, status, and severity
class IncidentCard extends StatelessWidget {
  final Incident incident;

  const IncidentCard({super.key, required this.incident});

  @override
  Widget build(BuildContext context) {
    // Determine status color
    Color statusColor;
    switch (incident.status) {
      case 'In Progress':
        statusColor = Colors.blue;
        break;
      case 'Resolved':
        statusColor = Colors.green;
        break;
      default:
        statusColor = Colors.red;
    }

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey, width: 1),
        boxShadow: [
          BoxShadow(
            color: const Color.fromARGB(75, 0, 0, 0),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                incident.title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Row(
                children: [
                  const Icon(Icons.bookmark, size: 16, color: Colors.black54),
                  const SizedBox(width: 4),
                  Text(
                    incident.severity,
                    style: const TextStyle(fontSize: 14, color: Colors.black54),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            incident.status,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: statusColor,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            incident.notes,
            style: const TextStyle(fontSize: 14, color: Colors.black54),
          ),
        ],
      ),
    );
  }
}
