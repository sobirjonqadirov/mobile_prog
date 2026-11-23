
import 'package:flutter/material.dart';

import '../models/classification_record.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({
    super.key,
    required this.records,
    required this.onOpenRecord,
  });

  final List<ClassificationRecord> records;
  final ValueChanged<ClassificationRecord> onOpenRecord;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (records.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.history,
                size: 64,
                color: theme.colorScheme.primary,
              ),
              const SizedBox(height: 16),
              Text(
                'No history yet',
                style: theme.textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              Text(
                'Your classified images will appear here.',
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: records.length,
      itemBuilder: (context, index) {
        final record = records[index];
        final top = record.topPrediction;

        return Card(
          child: ListTile(
            contentPadding: const EdgeInsets.all(12),
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.memory(
                record.imageBytes,
                width: 60,
                height: 60,
                fit: BoxFit.cover,
              ),
            ),
            title: Text(
              top.label,
              style: theme.textTheme.titleMedium,
            ),
            subtitle: Text(
              '${(top.confidence * 100).toStringAsFixed(1)}% '
              '• ${record.source}',
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  _sourceIcon(record.source),
                  color: theme.colorScheme.primary,
                  size: 21,
                ),
                const SizedBox(width: 8),
                const Icon(Icons.chevron_right),
              ],
            ),
            onTap: () => onOpenRecord(record),
          ),
        );
      },
    );
  }
}


IconData _sourceIcon(String source) {
  switch (source) {
    case 'Camera':
      return Icons.camera_alt_outlined;
    case 'Gallery':
      return Icons.photo_library_outlined;
    case 'Download':
      return Icons.cloud_download_outlined;
    case 'Sample':
      return Icons.science_outlined;
    default:
      return Icons.image_outlined;
  }
}
