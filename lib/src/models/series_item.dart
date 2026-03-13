import 'package:cloud_firestore/cloud_firestore.dart';

class SeriesItem {
  const SeriesItem({
    required this.id,
    required this.title,
    required this.description,
    required this.driveFolderUrl,
    required this.thumbnailUrl,
    required this.folderId,
    required this.syncStatus,
    required this.syncError,
  });

  final String id;
  final String title;
  final String description;
  final String driveFolderUrl;
  final String thumbnailUrl;
  final String folderId;
  final String syncStatus;
  final String syncError;

  factory SeriesItem.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? <String, dynamic>{};
    return SeriesItem(
      id: doc.id,
      title: (data['title'] ?? '') as String,
      description: (data['description'] ?? '') as String,
      driveFolderUrl: (data['driveFolderUrl'] ?? '') as String,
      thumbnailUrl: (data['thumbnailUrl'] ?? '') as String,
      folderId: (data['folderId'] ?? '') as String,
      syncStatus: (data['syncStatus'] ?? 'idle') as String,
      syncError: (data['syncError'] ?? '') as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'driveFolderUrl': driveFolderUrl,
      'thumbnailUrl': thumbnailUrl,
      'folderId': folderId,
      'syncStatus': syncStatus,
      'syncError': syncError,
      'updatedAt': FieldValue.serverTimestamp(),
    };
  }
}
