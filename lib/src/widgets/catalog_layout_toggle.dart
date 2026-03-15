import 'package:flutter/material.dart';

import '../localization/app_localization.dart';

enum CatalogLayoutMode { grid, list }

class CatalogLayoutToggle extends StatelessWidget {
  const CatalogLayoutToggle({
    super.key,
    required this.value,
    required this.onChanged,
  });

  final CatalogLayoutMode value;
  final ValueChanged<CatalogLayoutMode> onChanged;

  @override
  Widget build(BuildContext context) {
    final strings = context.strings;

    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: 10,
      runSpacing: 8,
      children: [
        Text(
          strings.viewModeLabel,
          style: const TextStyle(
            color: Colors.white70,
            fontWeight: FontWeight.w600,
          ),
        ),
        SegmentedButton<CatalogLayoutMode>(
          showSelectedIcon: false,
          segments: [
            ButtonSegment<CatalogLayoutMode>(
              value: CatalogLayoutMode.grid,
              icon: const Icon(Icons.grid_view_outlined),
              label: Text(strings.gridViewLabel),
            ),
            ButtonSegment<CatalogLayoutMode>(
              value: CatalogLayoutMode.list,
              icon: const Icon(Icons.view_agenda_outlined),
              label: Text(strings.listViewLabel),
            ),
          ],
          selected: {value},
          onSelectionChanged: (selection) {
            if (selection.isNotEmpty) {
              onChanged(selection.first);
            }
          },
        ),
      ],
    );
  }
}
