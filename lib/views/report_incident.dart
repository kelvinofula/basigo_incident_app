import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'dart:io';
import '../models/incident_model.dart';
import '../providers/incident_provider.dart';

class ReportIncidentScreen extends ConsumerStatefulWidget {
  const ReportIncidentScreen({super.key});

  @override
  _ReportIncidentScreenState createState() => _ReportIncidentScreenState();
}

class _ReportIncidentScreenState extends ConsumerState<ReportIncidentScreen> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController notesController = TextEditingController();
  String selectedSeverity = 'Low';
  final List<XFile> attachedMedia = [];
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickMedia() async {
    try {
      // Define platform-specific permissions
      final Permission cameraPermission = Permission.camera;
      final Permission galleryPermission =
          Platform.isAndroid ? Permission.storage : Permission.photos;

      // Check current status
      final Map<Permission, PermissionStatus> statuses =
          await [cameraPermission, galleryPermission].request();

      // Handle platform-specific permission results
      final cameraGranted = statuses[cameraPermission]?.isGranted ?? false;
      final galleryGranted = statuses[galleryPermission]?.isGranted ?? false;

      // Check if any permissions are permanently denied
      final cameraPermanentlyDenied =
          statuses[cameraPermission]?.isPermanentlyDenied ?? false;
      final galleryPermanentlyDenied =
          statuses[galleryPermission]?.isPermanentlyDenied ?? false;

      if (cameraPermanentlyDenied || galleryPermanentlyDenied) {
        _showSettingsDialog();
        return;
      }

      // Check if all permissions are granted
      if (cameraGranted && galleryGranted) {
        _showMediaPickerDialog();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Required permissions were not granted'),
          ),
        );
      }
    } on PlatformException catch (e) {
      print("Permission error: ${e.message}");
    }
  }

  void _showMediaPickerDialog() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Take Photo'),
              onTap: () async {
                Navigator.pop(context);
                final XFile? pickedFile = await _picker.pickImage(
                  source: ImageSource.camera,
                );
                if (pickedFile != null && attachedMedia.length < 3) {
                  setState(() {
                    attachedMedia.add(XFile(pickedFile.path));
                  });
                }
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Choose from Gallery'),
              onTap: () async {
                Navigator.pop(context);
                final List<XFile>? pickedFiles = await _picker.pickMultiImage();
                if (pickedFiles != null &&
                    pickedFiles.length + attachedMedia.length <= 3) {
                  setState(() {
                    attachedMedia.addAll(
                      pickedFiles.map((file) => XFile(file.path)),
                    );
                  });
                }
              },
            ),
          ],
        );
      },
    );
  }

  void _showSettingsDialog() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Permission Required'),
            content: Text(
              Platform.isAndroid
                  ? 'Camera and Photos access is required. Please enable them in settings.'
                  : 'Camera and Storage access is required. Please enable them in settings.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () async {
                  Navigator.pop(context);
                  await openAppSettings();
                },
                child: const Text('Open Settings'),
              ),
            ],
          ),
    );
  }

  // Convert image file to base64
  Future<String> _convertToBase64(String filePath) async {
    File file = File(filePath);
    List<int> imageBytes = await file.readAsBytes();

    // Compress the image
    List<int>? compressedBytes = await FlutterImageCompress.compressWithList(
      Uint8List.fromList(imageBytes),
      quality: 50, // Reduce quality to 50% to save space
      minWidth: 800, // Smaller width
      minHeight: 800, // Smaller height
    );

    return base64Encode(compressedBytes);
  }

  void _submitIncident(WidgetRef ref) async {
    if (titleController.text.isEmpty || notesController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('All fields must be filled in!')),
      );
      return;
    }

    List<String> base64Images = [];
    for (XFile file in attachedMedia) {
      String base64String = await _convertToBase64(file.path);

      // Ensure image does not exceed Firestore size limit
      if (base64String.length < 1000000) {
        base64Images.add(base64String);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Image too large after compression!')),
        );
      }
    }

    ref
        .read(incidentProvider.notifier)
        .addIncident(
          Incident(
            id: DateTime.now().toString(),
            title: titleController.text,
            severity: selectedSeverity,
            notes: notesController.text,
            mediaFiles: base64Images,
          ),
        );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Report Incident')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(labelText: 'Title*'),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: selectedSeverity,
              items:
                  ['Low', 'Medium', 'High']
                      .map(
                        (severity) => DropdownMenuItem(
                          value: severity,
                          child: Text(severity),
                        ),
                      )
                      .toList(),
              onChanged: (newValue) {
                if (newValue != null) {
                  setState(() => selectedSeverity = newValue);
                }
              },
              decoration: const InputDecoration(labelText: 'Severity*'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: notesController,
              decoration: const InputDecoration(labelText: 'Notes*'),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(0),
                ),
                backgroundColor: const Color.fromARGB(255, 248, 244, 244),
              ),
              onPressed: _pickMedia,
              child: const Text(
                'Attach Media (Max 3)',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.normal,
                  color: Colors.black,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 10,
              children:
                  attachedMedia
                      .map(
                        (file) => Image.file(
                          File(file.path),
                          width: 80,
                          height: 80,
                          fit: BoxFit.cover,
                        ),
                      )
                      .toList(),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(26),
                ),
                backgroundColor: Colors.black,
              ),
              onPressed: () => _submitIncident(ref),
              child: const Text(
                'Submit',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
