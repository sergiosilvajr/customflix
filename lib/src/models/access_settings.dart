import 'package:cloud_firestore/cloud_firestore.dart';

class AccessSettings {
  const AccessSettings({
    required this.allowedViewerEmails,
  });

  final List<String> allowedViewerEmails;

  bool get hasRestrictions => allowedViewerEmails.isNotEmpty;

  factory AccessSettings.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? <String, dynamic>{};
    final raw = (data['allowedViewerEmails'] as List<dynamic>? ?? const []);
    return AccessSettings(
      allowedViewerEmails: raw.map((item) => item.toString()).toList(),
    );
  }
}
