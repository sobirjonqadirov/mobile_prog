
import 'package:flutter/material.dart';

import '../models/classification_record.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({
    super.key,
    required this.onPreview,
    required this.onCamera,
    required this.onGallery,
    required this.onDownload,
    required this.latest,
    required this.onOpenLatest,
  });

  final VoidCallback onPreview;
  final VoidCallback onCamera;
  final VoidCallback onGallery;
  final VoidCallback onDownload;
  final ClassificationRecord? latest;
  final VoidCallback onOpenLatest;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Text(
          'Welcome to ObjectLens',
          style: theme.textTheme.headlineMedium,
        ),
        const SizedBox(height: 8),
        Text(
          'Choose how you want to recognize an object.',
          style: theme.textTheme.bodyLarge,
        ),
        const SizedBox(height: 24),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Icon(
                  Icons.auto_awesome,
                  size: 44,
                  color: theme.colorScheme.primary,
                ),
                const SizedBox(height: 12),
                Text(
                  'AI Image Recognition',
                  style: theme.textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                Text(
                  'Your trained model runs directly '
                  'on your device.',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyMedium,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 20),
        _ActionTile(
          icon: Icons.camera_alt_outlined,
          title: 'Take a photo',
          subtitle: 'Recognize an object using the camera',
          onTap: onCamera,
        ),
        _ActionTile(
          icon: Icons.photo_library_outlined,
          title: 'Choose from gallery',
          subtitle: 'Select a picture from your device',
          onTap: onGallery,
        ),
        _ActionTile(
          icon: Icons.link,
          title: 'Download an image',
          subtitle: 'Classify a picture from an image URL',
          onTap: onDownload,
        ),
        const SizedBox(height: 20),
        FilledButton.tonalIcon(
          onPressed: onPreview,
          icon: const Icon(Icons.science_outlined),
          label: const Text('Preview sample result'),
        ),
        const SizedBox(height: 28),
        Text(
          'Most Recent Result',
          style: theme.textTheme.titleLarge,
        ),
        const SizedBox(height: 12),
        if (latest == null)
          Card(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Text(
                'No classifications yet.',
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium,
              ),
            ),
          )
        else
          Card(
            child: ListTile(
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.memory(
                  latest!.imageBytes,
                  width: 52,
                  height: 52,
                  fit: BoxFit.cover,
                ),
              ),
              title: Text(latest!.topPrediction.label),
              subtitle: Text(
                '${(latest!.topPrediction.confidence * 100).toStringAsFixed(1)}% confidence',
              ),
              trailing: const Icon(Icons.chevron_right),
              onTap: onOpenLatest,
            ),
          ),
      ],
    );
  }
}

class _ActionTile extends StatelessWidget {
  const _ActionTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: Icon(
          icon,
          color: theme.colorScheme.primary,
          size: 30,
        ),
        title: Text(
          title,
          style: theme.textTheme.titleMedium,
        ),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}
