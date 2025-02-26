import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:typed_data';
import 'dart:convert';

class IncidentDetailScreen extends StatefulWidget {
  final String incidentId;
  final Map<String, dynamic> incidentData;

  const IncidentDetailScreen({
    super.key,
    required this.incidentId,
    required this.incidentData,
  });

  @override
  _IncidentDetailScreenState createState() => _IncidentDetailScreenState();
}

class _IncidentDetailScreenState extends State<IncidentDetailScreen> {
  late TextEditingController _notesController;
  late String _selectedStatus;

  @override
  void initState() {
    super.initState();
    _notesController = TextEditingController(
      text: widget.incidentData['notes'],
    );
    _selectedStatus = widget.incidentData['status'] ?? 'Pending';
  }

  void _updateIncident() {
    FocusScope.of(
      context,
    ).unfocus(); // Dismiss the keyboard when user taps on submit button
    FirebaseFirestore.instance
        .collection('incidents')
        .doc(widget.incidentId)
        .update({'status': _selectedStatus, 'notes': _notesController.text})
        .then((_) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Incident updated successfully!')),
          );
          Future.delayed(const Duration(seconds: 2), () {
            if (mounted) {
              Navigator.pop(context);
            }
          });
        })
        .catchError((error) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to update incident: $error')),
          );
        });
  }

  Widget _buildMediaWidget(String media) {
    // Decode Base64 string
    try {
      Uint8List imageBytes = base64Decode(media);
      return ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.memory(
          imageBytes,
          width: 100,
          height: 100,
          fit: BoxFit.cover,
        ),
      );
    } catch (e) {
      return const SizedBox();
    }
  }

  @override
  Widget build(BuildContext context) {
    List<String> mediaFiles = List<String>.from(
      widget.incidentData['mediaFiles'] ?? [],
    );

    return Scaffold(
      appBar: AppBar(title: const Text('Incident Information')),
      body: GestureDetector(
        onTap:
            () =>
                FocusScope.of(
                  context,
                ).unfocus(), // Dismiss keyboard when user taps
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.incidentData['title'] ?? 'Unknown Incident',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: _selectedStatus,
                items:
                    ['Pending', 'In Progress', 'Resolved'].map((status) {
                      return DropdownMenuItem(
                        value: status,
                        child: Text(status),
                      );
                    }).toList(),
                onChanged: (newValue) {
                  if (newValue != null) {
                    setState(() {
                      _selectedStatus = newValue;
                    });
                  }
                },
                decoration: const InputDecoration(labelText: 'Status'),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _notesController,
                decoration: const InputDecoration(
                  labelText: 'Notes',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 16),
              if (mediaFiles.isNotEmpty) ...[
                const Text(
                  'Attached Media:',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  children:
                      mediaFiles
                          .map((media) => _buildMediaWidget(media))
                          .toList(),
                ),
                const SizedBox(height: 24),
              ],
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(26),
                    ),
                    backgroundColor: Colors.black,
                  ),
                  onPressed: _updateIncident,
                  child: const Text(
                    'Submit',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
