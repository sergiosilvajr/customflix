import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../auth/access_control.dart';
import '../localization/app_localization.dart';
import '../models/series_item.dart';
import '../models/video_item.dart';
import '../utils/drive_link_utils.dart';
import '../widgets/drive_player.dart';

class PlayerPage extends StatelessWidget {
  const PlayerPage({super.key, required this.series, required this.video});

  final SeriesItem series;
  final VideoItem video;

  @override
  Widget build(BuildContext context) {
    final previewUrl = DriveLinkUtils.toPreviewUrl(video.driveFileUrl);
    final currentUser = FirebaseAuth.instance.currentUser;
    final isAdmin = currentUser != null && isAdminUser(currentUser);
    final strings = context.strings;

    return Scaffold(
      appBar: AppBar(title: Text('${series.title} - ${video.title}')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          AspectRatio(
            aspectRatio: 16 / 9,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: DrivePlayer(previewUrl: previewUrl),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            video.title,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 6),
          Text(
            video.description.isEmpty ? strings.noDescription : video.description,
            style: const TextStyle(color: Colors.white70),
          ),
          if (isAdmin) ...[
            const SizedBox(height: 12),
            SelectableText(
              '${strings.originalLinkLabel}: ${video.driveFileUrl}',
              style: const TextStyle(color: Colors.white54, fontSize: 12),
            ),
          ],
        ],
      ),
    );
  }
}
