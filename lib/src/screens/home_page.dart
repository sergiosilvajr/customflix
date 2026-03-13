import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../auth/auth_service.dart';
import '../localization/app_localization.dart';
import '../models/series_item.dart';
import '../repositories/catalog_repository.dart';
import '../widgets/catalog_thumbnail.dart';
import 'admin_page.dart';
import 'series_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.user, required this.isAdmin});

  final User user;
  final bool isAdmin;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _searchCtrl = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  final ValueNotifier<String> _queryNotifier = ValueNotifier<String>('');

  @override
  void dispose() {
    _searchCtrl.dispose();
    _searchFocusNode.dispose();
    _queryNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final strings = context.strings;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'CUSTOMFLIX',
          style: TextStyle(
            color: Color(0xFFE50914),
            fontWeight: FontWeight.w700,
            letterSpacing: 1.4,
          ),
        ),
        actions: [
          _LanguageSwitcher(
            currentLanguage: context.languageController.language,
            onChanged: context.languageController.setLanguage,
          ),
          if (widget.isAdmin)
            TextButton.icon(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const AdminPage()),
                );
              },
              icon: const Icon(Icons.settings),
              label: Text(strings.admin),
            ),
          TextButton.icon(
            onPressed: AuthService.instance.signOut,
            icon: const Icon(Icons.logout),
            label: Text(widget.user.displayName ?? strings.logoutFallback),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              strings.seriesTitle,
              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 12),
            ValueListenableBuilder<String>(
              valueListenable: _queryNotifier,
              builder: (context, query, _) {
                return TextField(
                  controller: _searchCtrl,
                  focusNode: _searchFocusNode,
                  onChanged: (value) => _queryNotifier.value = value,
                  decoration: InputDecoration(
                    hintText: strings.searchSeriesHint,
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: query.isEmpty
                        ? null
                        : IconButton(
                            onPressed: () {
                              _searchCtrl.clear();
                              _queryNotifier.value = '';
                              _searchFocusNode.requestFocus();
                            },
                            icon: const Icon(Icons.close),
                          ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ValueListenableBuilder<String>(
                valueListenable: _queryNotifier,
                builder: (context, queryValue, _) {
                  return StreamBuilder<List<SeriesItem>>(
                    stream: CatalogRepository.instance.watchSeries(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      final allSeries = snapshot.data ?? const <SeriesItem>[];
                      final query = queryValue.trim().toLowerCase();
                      final filteredSeries = allSeries.where((item) {
                        if (query.isEmpty) {
                          return true;
                        }

                        return item.title.toLowerCase().contains(query) ||
                            item.description.toLowerCase().contains(query);
                      }).toList();

                      if (filteredSeries.isEmpty) {
                        return ListView(
                          children: [
                            Card(
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Text(
                                  allSeries.isEmpty
                                      ? strings.noSeriesYet
                                      : strings.noSeriesFound(queryValue),
                                ),
                              ),
                            ),
                          ],
                        );
                      }

                      return SingleChildScrollView(
                        child: Wrap(
                          spacing: 12,
                          runSpacing: 12,
                          children: filteredSeries
                              .map(
                                (item) => SizedBox(
                                  width: 250,
                                  child: _SeriesCard(series: item),
                                ),
                              )
                              .toList(),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SeriesCard extends StatelessWidget {
  const _SeriesCard({required this.series});

  final SeriesItem series;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => SeriesPage(series: series)),
        );
      },
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AspectRatio(
              aspectRatio: 16 / 9,
              child: CatalogThumbnail(
                imageUrl: series.thumbnailUrl,
                emptyIcon: Icons.movie,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    series.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    series.description,
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

class _LanguageSwitcher extends StatelessWidget {
  const _LanguageSwitcher({
    required this.currentLanguage,
    required this.onChanged,
  });

  final AppLanguage currentLanguage;
  final ValueChanged<AppLanguage> onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<AppLanguage>(
          value: currentLanguage,
          borderRadius: BorderRadius.circular(12),
          dropdownColor: const Color(0xFF1A1A1A),
          iconEnabledColor: Colors.white70,
          onChanged: (value) {
            if (value != null) {
              onChanged(value);
            }
          },
          items: const [
            DropdownMenuItem(
              value: AppLanguage.ptBr,
              child: Text('PT-BR'),
            ),
            DropdownMenuItem(
              value: AppLanguage.en,
              child: Text('EN'),
            ),
          ],
        ),
      ),
    );
  }
}
