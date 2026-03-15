import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/access_settings.dart';
import '../models/series_item.dart';
import '../models/video_item.dart';

class CatalogRepository {
  CatalogRepository._();

  static final instance = CatalogRepository._();

  final FirebaseFirestore _db = FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _seriesRef =>
      _db.collection('series');
  DocumentReference<Map<String, dynamic>> get _accessSettingsRef =>
      _db.collection('settings').doc('access');

  Stream<List<SeriesItem>> watchSeries() {
    return _seriesRef.orderBy('title').snapshots().map((snapshot) {
      return snapshot.docs.map(SeriesItem.fromDoc).toList();
    });
  }

  Stream<AccessSettings> watchAccessSettings() {
    return _accessSettingsRef.snapshots().map(AccessSettings.fromDoc);
  }

  Future<AccessSettings> fetchAccessSettings() async {
    final snapshot = await _accessSettingsRef.get();
    return AccessSettings.fromDoc(snapshot);
  }

  Future<List<SeriesItem>> fetchSeries() async {
    final snapshot = await _seriesRef.orderBy('title').get();
    return snapshot.docs.map(SeriesItem.fromDoc).toList();
  }

  Stream<List<VideoItem>> watchVideos(String seriesId) {
    return _seriesRef
        .doc(seriesId)
        .collection('videos')
        .orderBy('episodeNumber')
        .snapshots()
        .map((snapshot) {
          final videos = snapshot.docs.map(VideoItem.fromDoc).toList();
          videos.sort(_compareVideos);
          return videos;
        });
  }

  Future<void> upsertSeries({String? seriesId, required SeriesItem value}) async {
    final doc = seriesId == null || seriesId.isEmpty
        ? _seriesRef.doc()
        : _seriesRef.doc(seriesId);
    final payload = <String, dynamic>{
      'title': value.title,
      'description': value.description,
      'driveFolderUrl': value.driveFolderUrl,
      'updatedAt': FieldValue.serverTimestamp(),
      'createdAt': FieldValue.serverTimestamp(),
      'syncRequestedAt': FieldValue.serverTimestamp(),
      'syncStatus': 'pending',
      'syncError': FieldValue.delete(),
    };

    if (value.thumbnailUrl.isNotEmpty) {
      payload['thumbnailUrl'] = value.thumbnailUrl;
    }

    await doc.set(payload, SetOptions(merge: true));
  }

  Future<void> upsertVideo({
    required String seriesId,
    String? videoId,
    required VideoItem value,
  }) async {
    final videosRef = _seriesRef.doc(seriesId).collection('videos');
    final doc = videoId == null || videoId.isEmpty
        ? videosRef.doc()
        : videosRef.doc(videoId);
    final payload = <String, dynamic>{
      'title': value.title,
      'description': value.description,
      'driveFileUrl': value.driveFileUrl,
      'episodeNumber': value.episodeNumber,
      'updatedAt': FieldValue.serverTimestamp(),
      'createdAt': FieldValue.serverTimestamp(),
    };

    if (value.driveFileId.isNotEmpty) {
      payload['driveFileId'] = value.driveFileId;
    }

    if (value.thumbnailUrl.isNotEmpty) {
      payload['thumbnailUrl'] = value.thumbnailUrl;
    }

    await doc.set(payload, SetOptions(merge: true));
  }

  Future<void> deleteSeries(String seriesId) async {
    final seriesDoc = _seriesRef.doc(seriesId);
    final videosSnapshot = await seriesDoc.collection('videos').get();
    final batch = _db.batch();

    for (final doc in videosSnapshot.docs) {
      batch.delete(doc.reference);
    }

    batch.delete(seriesDoc);
    await batch.commit();
  }

  Future<void> requestSeriesResync(String seriesId) async {
    await _seriesRef.doc(seriesId).set({
      'syncRequestedAt': FieldValue.serverTimestamp(),
      'syncStatus': 'pending',
      'syncError': FieldValue.delete(),
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  Future<void> addAllowedViewerEmail(String email) async {
    await _accessSettingsRef.set({
      'allowedViewerEmails': FieldValue.arrayUnion([email]),
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  Future<void> removeAllowedViewerEmail(String email) async {
    await _accessSettingsRef.set({
      'allowedViewerEmails': FieldValue.arrayRemove([email]),
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  int _compareVideos(VideoItem a, VideoItem b) {
    final aSortKey = a.sortKey.trim();
    final bSortKey = b.sortKey.trim();
    if (aSortKey.isNotEmpty || bSortKey.isNotEmpty) {
      final bySortKey = aSortKey.compareTo(bSortKey);
      if (bySortKey != 0) {
        return bySortKey;
      }
    }

    final bySeason = a.seasonNumber.compareTo(b.seasonNumber);
    if (bySeason != 0) {
      return bySeason;
    }

    final aOrder = _extractEpisodeOrder(a.title, a.episodeNumber);
    final bOrder = _extractEpisodeOrder(b.title, b.episodeNumber);

    final byOrder = aOrder.compareTo(bOrder);
    if (byOrder != 0) {
      return byOrder;
    }

    final byPart = a.partNumber.compareTo(b.partNumber);
    if (byPart != 0) {
      return byPart;
    }

    final byTitle = a.title.toLowerCase().compareTo(b.title.toLowerCase());
    if (byTitle != 0) {
      return byTitle;
    }

    return a.id.compareTo(b.id);
  }

  int _extractEpisodeOrder(String title, int fallback) {
    final patterns = <RegExp>[
      RegExp(r'\bs\d{1,2}\s*e\s*0*(\d{1,4})\b', caseSensitive: false),
      RegExp(
        r'\b(?:ep|episode|episodio|episódio|capitulo|capítulo)\s*0*(\d{1,4})\b',
        caseSensitive: false,
      ),
      RegExp(r'\b0*(\d{1,4})\b'),
    ];

    for (final pattern in patterns) {
      final match = pattern.firstMatch(title);
      final value = match?.group(1);
      if (value != null) {
        return int.tryParse(value) ?? fallback;
      }
    }

    return fallback;
  }
}
