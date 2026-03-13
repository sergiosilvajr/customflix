import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../auth/access_control.dart';
import '../localization/app_localization.dart';
import '../models/series_item.dart';
import '../models/video_item.dart';
import '../repositories/catalog_repository.dart';
import '../widgets/catalog_thumbnail.dart';
import 'player_page.dart';

class SeriesPage extends StatelessWidget {
  const SeriesPage({super.key, required this.series});

  final SeriesItem series;

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;
    final isAdmin = currentUser != null && isAdminUser(currentUser);
    final strings = context.strings;

    return Scaffold(
      appBar: AppBar(title: Text(series.title)),
      body: StreamBuilder<List<VideoItem>>(
        stream: CatalogRepository.instance.watchVideos(series.id),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final videos = snapshot.data ?? const <VideoItem>[];
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Text(
                series.description,
                style: const TextStyle(color: Colors.white70),
              ),
              if (isAdmin && series.driveFolderUrl.isNotEmpty) ...[
                const SizedBox(height: 8),
                SelectableText(
                  '${strings.driveFolderLabel}: ${series.driveFolderUrl}',
                  style: const TextStyle(color: Colors.white54, fontSize: 12),
                ),
              ],
              const SizedBox(height: 18),
              Text(
                strings.episodes,
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 12),
              if (videos.isEmpty)
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(strings.noVideosInSeries),
                  ),
                ),
              if (videos.isNotEmpty)
                LayoutBuilder(
                  builder: (context, constraints) {
                    final width = constraints.maxWidth;
                    int crossAxisCount = 2;
                    if (width >= 1200) {
                      crossAxisCount = 5;
                    } else if (width >= 900) {
                      crossAxisCount = 4;
                    } else if (width >= 600) {
                      crossAxisCount = 3;
                    }

                    return GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: videos.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: crossAxisCount,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        childAspectRatio: 0.78,
                      ),
                      itemBuilder: (context, index) {
                        final video = videos[index];
                        return _EpisodeCard(series: series, video: video);
                      },
                    );
                  },
                ),
            ],
          );
        },
      ),
    );
  }
}

class _EpisodeCard extends StatelessWidget {
  const _EpisodeCard({required this.series, required this.video});

  final SeriesItem series;
  final VideoItem video;

  @override
  Widget build(BuildContext context) {
    final strings = context.strings;

    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => PlayerPage(series: series, video: video),
          ),
        );
      },
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Stack(
                fit: StackFit.expand,
                children: [
                  CatalogThumbnail(
                    imageUrl: video.thumbnailUrl,
                    emptyIcon: Icons.ondemand_video,
                  ),
                  Positioned(
                    top: 10,
                    left: 10,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.72),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text(
                        'EP ${video.episodeNumber}',
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                  const Positioned(
                    right: 10,
                    bottom: 10,
                    child: CircleAvatar(
                      backgroundColor: Color(0xCC000000),
                      child: Icon(Icons.play_arrow),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    video.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    video.description.isEmpty
                        ? strings.noDescription
                        : video.description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: Colors.white70),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
