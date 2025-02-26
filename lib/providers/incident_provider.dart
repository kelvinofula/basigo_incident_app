import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hive/hive.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import '../models/incident_model.dart';

// State Management Provider
final incidentProvider =
    StateNotifierProvider<IncidentNotifier, List<Incident>>(
      (ref) => IncidentNotifier(),
    );

class IncidentNotifier extends StateNotifier<List<Incident>> {
  IncidentNotifier() : super([]) {
    _fetchIncidents();
    _syncOfflineIncidents();
  }

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void addIncident(Incident incident) {
    state = [...state, incident];
    _saveToLocal(incident);
    _uploadToFirestore(incident);
  }

  void _saveToLocal(Incident incident) async {
    final box = await Hive.openBox<Incident>('incidents');
    await box.put(incident.id, incident);
  }

  void _uploadToFirestore(Incident incident) async {
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      _firestore.collection('incidents').doc(incident.id).set({
        ...incident.toMap(),
        'userId': user.uid, // Store user ID
      });
    } else {
      print("User not authenticated!");
    }
  }

  void _fetchIncidents() {
    _firestore.collection('incidents').snapshots().listen((snapshot) {
      final incidents =
          snapshot.docs.map((doc) => Incident.fromMap(doc.data())).toList();
      state = incidents;
    });
  }

  void _syncOfflineIncidents() async {
    final box = await Hive.openBox<Incident>('incidents');
    final incidents =
        box.values.where((incident) => !incident.isSynced).toList();

    Connectivity().onConnectivityChanged.listen((
      List<ConnectivityResult> results,
    ) {
      if (results.isNotEmpty && results.first != ConnectivityResult.none) {
        for (var incident in incidents) {
          _uploadToFirestore(incident);
        }
      }
    });
  }

  // Clear all saved incidents
  Future<void> clearAllIncidents() async {
    final box = await Hive.openBox<Incident>('incidents');
    await box.clear();
    state = [];
    await _firestore.collection('incidents').get().then((snapshot) {
      for (var doc in snapshot.docs) {
        doc.reference.delete();
      }
    });
  }
}
