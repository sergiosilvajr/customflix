class DriveLinkUtils {
  DriveLinkUtils._();

  static String toPreviewUrl(String link) {
    final fileId = extractFileId(link);
    if (fileId == null) {
      return link;
    }
    return 'https://drive.google.com/file/d/$fileId/preview';
  }

  static String? extractFileId(String link) {
    final direct = RegExp(r'/file/d/([a-zA-Z0-9_-]+)').firstMatch(link);
    if (direct != null) {
      return direct.group(1);
    }

    final openId = RegExp(r'[?&]id=([a-zA-Z0-9_-]+)').firstMatch(link);
    if (openId != null) {
      return openId.group(1);
    }

    final ucId = RegExp(r'/uc\?export=download&id=([a-zA-Z0-9_-]+)')
        .firstMatch(link);
    if (ucId != null) {
      return ucId.group(1);
    }

    return null;
  }
}
