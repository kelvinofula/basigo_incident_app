import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'report_incident.dart';
import '../providers/incident_provider.dart';
import '../components/empty_state.dart';
import '../components/incident_card.dart';

class DriverHomePage extends ConsumerWidget {
  const DriverHomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final incidents = ref.watch(incidentProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Driver Dashboard')),
      body:
          incidents.isEmpty
              ? const EmptyState()
              : Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListView.builder(
                  itemCount: incidents.length,
                  itemBuilder: (context, index) {
                    return IncidentCard(incident: incidents[index]);
                  },
                ),
              ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed:
            () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ReportIncidentScreen()),
            ),
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text(
          'Report New Incident',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.black,
      ),
    );
  }
}
