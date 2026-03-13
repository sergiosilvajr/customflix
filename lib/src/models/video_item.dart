import 'package:cloud_firestore/cloud_firestore.dart';

class VideoItem {
  const VideoItem({
    required this.id,
    required this.title,
    required this.description,
    required this.driveFileUrl,
    required this.driveFileId,
    required this.thumbnailUrl,
    required this.episodeNumber,
  });

  final String id;
  final String title;
  final String description;
  final String driveFileUrl;
  final String driveFileId;
  final String thumbnailUrl;
  final int episodeNumber;

  factory VideoItem.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? <String, dynamic>{};
    return VideoItem(
      id: doc.id,
      title: (data['title'] ?? '') as String,
      description: (data['description'] ?? '') as String,
      driveFileUrl: (data['driveFileUrl'] ?? '') as String,
      driveFileId: (data['driveFileId'] ?? '') as String,
      thumbnailUrl: (data['thumbnailUrl'] ?? '') as String,
      episodeNumber: (data['episodeNumber'] ?? 0) as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'driveFileUrl': driveFileUrl,
      'driveFileId': driveFileId,
      'thumbnailUrl': thumbnailUrl,
      'episodeNumber': episodeNumber,
      'updatedAt': FieldValue.serverTimestamp(),
    };
  }
}
