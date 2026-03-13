import 'package:flutter/material.dart';

import '../localization/app_localization.dart';

class DrivePlayer extends StatelessWidget {
  const DrivePlayer({super.key, required this.previewUrl});

  final String previewUrl;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(context.strings.playerOnlyWeb),
    );
  }
}
