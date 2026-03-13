import 'dart:ui_web' as ui_web;

import 'package:flutter/material.dart';
import 'package:web/web.dart' as web;

class DrivePlayer extends StatefulWidget {
  const DrivePlayer({super.key, required this.previewUrl});

  final String previewUrl;

  @override
  State<DrivePlayer> createState() => _DrivePlayerState();
}

class _DrivePlayerState extends State<DrivePlayer> {
  late final String _viewType;

  @override
  void initState() {
    super.initState();
    _viewType = 'drive-player-${widget.previewUrl.hashCode}-${DateTime.now().microsecondsSinceEpoch}';

    ui_web.platformViewRegistry.registerViewFactory(_viewType, (int viewId) {
      final iframe = web.HTMLIFrameElement()
        ..src = widget.previewUrl
        ..style.border = '0'
        ..style.width = '100%'
        ..style.height = '100%'
        ..allowFullscreen = true;

      return iframe;
    });
  }

  @override
  Widget build(BuildContext context) {
    return HtmlElementView(viewType: _viewType);
  }
}
