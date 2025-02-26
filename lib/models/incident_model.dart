// Incident Model
class Incident {
  final String id;
  final String title;
  final String severity;
  final String notes;
  final String status;
  final bool isSynced;
  final List<String> mediaFiles;

  Incident({
    required this.id,
    required this.title,
    required this.severity,
    required this.notes,
    this.status = 'Pending',
    this.isSynced = false,
    this.mediaFiles = const [], // Default to an empty list
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'severity': severity,
      'notes': notes,
      'status': status,
      'isSynced': isSynced,
      'mediaFiles': mediaFiles,
    };
  }

  static Incident fromMap(Map<String, dynamic> map) {
    return Incident(
      id: map['id'],
      title: map['title'],
      severity: map['severity'],
      notes: map['notes'],
      status: map['status'] ?? 'Pending',
      isSynced: map['isSynced'] ?? false,
      mediaFiles: List<String>.from(map['mediaFiles'] ?? []),
    );
  }
}
