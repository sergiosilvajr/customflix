import 'package:flutter/material.dart';

class CatalogThumbnail extends StatelessWidget {
  const CatalogThumbnail({
    super.key,
    required this.imageUrl,
    required this.emptyIcon,
  });

  final String imageUrl;
  final IconData emptyIcon;

  @override
  Widget build(BuildContext context) {
    if (imageUrl.isEmpty) {
      return Container(
        color: const Color(0xFF282828),
        child: Icon(emptyIcon, size: 40),
      );
    }

    return Image.network(
      imageUrl,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) {
        return Container(
          color: const Color(0xFF282828),
          child: Icon(emptyIcon, size: 40),
        );
      },
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) {
          return child;
        }

        return Container(
          color: const Color(0xFF202020),
          alignment: Alignment.center,
          child: const CircularProgressIndicator(strokeWidth: 2),
        );
      },
    );
  }
}
