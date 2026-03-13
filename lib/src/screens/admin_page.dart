import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../auth/access_control.dart';
import '../localization/app_localization.dart';
import '../models/series_item.dart';
import '../models/video_item.dart';
import '../repositories/catalog_repository.dart';

class AdminPage extends StatefulWidget {
  const AdminPage({super.key});

  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  final _seriesFormKey = GlobalKey<FormState>();
  final _viewerEmailCtrl = TextEditingController();

  final _seriesIdCtrl = TextEditingController();
  final _seriesTitleCtrl = TextEditingController();
  final _seriesDescriptionCtrl = TextEditingController();
  final _seriesDriveFolderCtrl = TextEditingController();
  final _seriesThumbCtrl = TextEditingController();

  bool _savingSeries = false;
  bool _savingViewerEmail = false;
  String? _deletingSeriesId;

  @override
  void dispose() {
    _seriesIdCtrl.dispose();
    _seriesTitleCtrl.dispose();
    _seriesDescriptionCtrl.dispose();
    _seriesDriveFolderCtrl.dispose();
    _seriesThumbCtrl.dispose();
    _viewerEmailCtrl.dispose();
    super.dispose();
  }

  Future<void> _saveSeries() async {
    if (!_seriesFormKey.currentState!.validate()) {
      return;
    }

    setState(() => _savingSeries = true);
    try {
      final series = SeriesItem(
        id: _seriesIdCtrl.text.trim(),
        title: _seriesTitleCtrl.text.trim(),
        description: _seriesDescriptionCtrl.text.trim(),
        driveFolderUrl: _seriesDriveFolderCtrl.text.trim(),
        thumbnailUrl: _seriesThumbCtrl.text.trim(),
        folderId: '',
        syncStatus: 'pending',
        syncError: '',
      );

      await CatalogRepository.instance.upsertSeries(
        seriesId: _seriesIdCtrl.text.trim().isEmpty ? null : _seriesIdCtrl.text.trim(),
        value: series,
      );

      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            context.strings.seriesSaved,
          ),
        ),
      );
    } catch (e) {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.strings.saveSeriesError(e))),
      );
    } finally {
      if (mounted) {
        setState(() => _savingSeries = false);
      }
    }
  }

  void _populateSeriesForm(SeriesItem series) {
    _seriesIdCtrl.text = series.id;
    _seriesTitleCtrl.text = series.title;
    _seriesDescriptionCtrl.text = series.description;
    _seriesDriveFolderCtrl.text = series.driveFolderUrl;
    _seriesThumbCtrl.text = series.thumbnailUrl;
    setState(() {});
  }

  void _populateVideoForm(String seriesId, VideoItem video) {
    final seriesTitle = _seriesTitleCtrl.text.trim();
    final titleLabel = seriesTitle.isEmpty ? seriesId : seriesTitle;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '${context.strings.edit}: $titleLabel - ${video.title}',
        ),
      ),
    );
  }

  void _clearSeriesForm() {
    _seriesIdCtrl.clear();
    _seriesTitleCtrl.clear();
    _seriesDescriptionCtrl.clear();
    _seriesDriveFolderCtrl.clear();
    _seriesThumbCtrl.clear();
    setState(() {});
  }

  Future<void> _deleteSeries(SeriesItem series) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(context.strings.deleteSeriesTitle),
        content: Text(
          context.strings.deleteSeriesPrompt(series.title),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(context.strings.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(context.strings.delete),
          ),
        ],
      ),
    );

    if (confirmed != true) {
      return;
    }

    setState(() => _deletingSeriesId = series.id);
    try {
      await CatalogRepository.instance.deleteSeries(series.id);

      if (_seriesIdCtrl.text.trim() == series.id) {
        _clearSeriesForm();
      }

      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.strings.seriesDeleted)),
      );
    } catch (e) {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.strings.deleteSeriesError(e))),
      );
    } finally {
      if (mounted) {
        setState(() => _deletingSeriesId = null);
      }
    }
  }

  Future<void> _addViewerEmail() async {
    final email = _viewerEmailCtrl.text.trim().toLowerCase();
    final emailRegex = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');
    if (!emailRegex.hasMatch(email)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.strings.invalidEmail)),
      );
      return;
    }

    setState(() => _savingViewerEmail = true);
    try {
      await CatalogRepository.instance.addAllowedViewerEmail(email);
      _viewerEmailCtrl.clear();
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.strings.emailAdded)),
      );
    } catch (e) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.strings.addEmailError(e))),
      );
    } finally {
      if (mounted) {
        setState(() => _savingViewerEmail = false);
      }
    }
  }

  Future<void> _removeViewerEmail(String email) async {
    try {
      await CatalogRepository.instance.removeAllowedViewerEmail(email);
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.strings.emailRemoved)),
      );
    } catch (e) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.strings.removeEmailError(e))),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null || !isAdminUser(currentUser)) {
      return Scaffold(
        appBar: AppBar(title: Text(context.strings.adminCatalogTitle)),
        body: Center(
          child: Text(context.strings.restrictedAdminAccess),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text(context.strings.adminCatalogTitle)),
      body: StreamBuilder<List<SeriesItem>>(
        stream: CatalogRepository.instance.watchSeries(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final seriesList = snapshot.data ?? const <SeriesItem>[];

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              const _SyncInfoCard(),
              const SizedBox(height: 16),
              _buildViewerAccessCard(),
              const SizedBox(height: 16),
              _buildSeriesForm(),
              const SizedBox(height: 24),
              Text(
                context.strings.registeredSeries,
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 12),
              if (seriesList.isEmpty)
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(context.strings.noSeriesYet),
                  ),
                )
              else
                ...seriesList.map(_buildSeriesCard),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSeriesForm() {
    final strings = context.strings;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _seriesFormKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                strings.seriesFormTitle,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              _textField(_seriesIdCtrl, strings.seriesIdField),
              _textField(
                _seriesTitleCtrl,
                strings.seriesTitleField,
                validator: _required,
              ),
              _textField(
                _seriesDescriptionCtrl,
                strings.seriesDescriptionField,
                maxLines: 3,
                validator: _required,
              ),
              _textField(
                _seriesDriveFolderCtrl,
                strings.seriesFolderField,
                validator: _required,
              ),
              _textField(
                _seriesThumbCtrl,
                strings.seriesThumbField,
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  FilledButton(
                    onPressed: _savingSeries ? null : _saveSeries,
                    child: Text(_savingSeries ? strings.saving : strings.saveAndSync),
                  ),
                  const SizedBox(width: 12),
                  TextButton(
                    onPressed: _clearSeriesForm,
                    child: Text(strings.clear),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildViewerAccessCard() {
    final strings = context.strings;

    return StreamBuilder(
      stream: CatalogRepository.instance.watchAccessSettings(),
      builder: (context, snapshot) {
        final settings = snapshot.data;
        final allowedEmails = settings?.allowedViewerEmails ?? const <String>[];

        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  strings.viewerAccessTitle,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  strings.viewerAccessDescription,
                  style: const TextStyle(color: Colors.white70),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _viewerEmailCtrl,
                        decoration: InputDecoration(
                          labelText: strings.viewerEmailField,
                          border: const OutlineInputBorder(),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    FilledButton(
                      onPressed: _savingViewerEmail ? null : _addViewerEmail,
                      child: Text(
                        _savingViewerEmail ? strings.saving : strings.addEmail,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                if (allowedEmails.isEmpty)
                  Text(
                    strings.noViewerRestrictions,
                    style: const TextStyle(color: Colors.white70),
                  )
                else
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: allowedEmails
                        .map(
                          (email) => Chip(
                            label: Text(email),
                            onDeleted: () => _removeViewerEmail(email),
                          ),
                        )
                        .toList(),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSeriesCard(SeriesItem series) {
    final isDeleting = _deletingSeriesId == series.id;
    final strings = context.strings;

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: ExpansionTile(
        title: Text(series.title),
        subtitle: Text(
          strings.syncStatus(series.syncStatus, series.syncError),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            FilledButton.tonal(
              onPressed: isDeleting ? null : () => _populateSeriesForm(series),
              child: Text(strings.editSeries),
            ),
            const SizedBox(width: 8),
            IconButton(
              onPressed: isDeleting ? null : () => _deleteSeries(series),
              tooltip: strings.deleteSeriesTooltip,
              icon: isDeleting
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.delete_outline),
            ),
          ],
        ),
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                '${context.strings.driveFolderLabel}: ${series.driveFolderUrl}',
                style: const TextStyle(color: Colors.white70),
              ),
            ),
          ),
          StreamBuilder<List<VideoItem>>(
            stream: CatalogRepository.instance.watchVideos(series.id),
            builder: (context, snapshot) {
              final videos = snapshot.data ?? const <VideoItem>[];
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Padding(
                  padding: EdgeInsets.all(16),
                  child: CircularProgressIndicator(),
                );
              }

              if (videos.isEmpty) {
                return Padding(
                  padding: EdgeInsets.fromLTRB(16, 0, 16, 16),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(strings.noSyncedEpisodes),
                  ),
                );
              }

              return Column(
                children: videos
                    .map(
                      (video) => ListTile(
                        leading: CircleAvatar(
                          child: Text(video.episodeNumber.toString()),
                        ),
                        title: Text(video.title),
                        subtitle: Text(
                          video.description.isEmpty
                              ? video.driveFileUrl
                              : video.description,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        trailing: TextButton(
                          onPressed: () => _populateVideoForm(series.id, video),
                          child: Text(strings.edit),
                        ),
                      ),
                    )
                    .toList(),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _textField(
    TextEditingController controller,
    String label, {
    String? Function(String?)? validator,
    int maxLines = 1,
    TextInputType? keyboardType,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: controller,
        maxLines: maxLines,
        keyboardType: keyboardType,
        validator: validator,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }

  String? _required(String? value) {
    if (value == null || value.trim().isEmpty) {
      return context.strings.requiredField;
    }
    return null;
  }
}

class _SyncInfoCard extends StatelessWidget {
  const _SyncInfoCard();

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Text(
          context.strings.syncInfo,
        ),
      ),
    );
  }
}
