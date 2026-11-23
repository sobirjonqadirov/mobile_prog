
import 'package:flutter/material.dart';

import '../models/classification_record.dart';

class ResultScreen extends StatelessWidget {
  const ResultScreen({
    super.key,
    required this.record,
  });

  final ClassificationRecord record;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Result'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Center(
              child: Text(record.source),
            ),
          ),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return ListView(
            padding: const EdgeInsets.all(20),
            children: [
              Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxHeight: constraints.maxHeight * 0.45,
                  ),
                  child: Image.memory(
                    record.imageBytes,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Classification Results',
                style: theme.textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              Text(
                'Predictions from your trained model',
                style: theme.textTheme.bodyMedium,
              ),
              const SizedBox(height: 20),
              for (var i = 0;
                  i < record.predictions.length;
                  i++)
                Padding(
                  padding: const EdgeInsets.only(bottom: 18),
                  child: _PredictionRow(
                    label: record.predictions[i].label,
                    confidence:
                        record.predictions[i].confidence,
                    isTop: i == 0,
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}

class _PredictionRow extends StatelessWidget {
  const _PredictionRow({
    required this.label,
    required this.confidence,
    required this.isTop,
  });

  final String label;
  final double confidence;
  final bool isTop;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                label,
                style: isTop
                    ? theme.textTheme.titleMedium
                    : theme.textTheme.bodyLarge,
              ),
            ),
            Text(
              '${(confidence * 100).toStringAsFixed(1)}%',
              style: isTop
                  ? theme.textTheme.titleMedium
                  : theme.textTheme.bodyLarge,
            ),
          ],
        ),
        const SizedBox(height: 8),
        LinearProgressIndicator(
          value: confidence.clamp(0.0, 1.0),
          minHeight: isTop ? 10 : 7,
          borderRadius: BorderRadius.circular(8),
          color: isTop
              ? theme.colorScheme.primary
              : theme.colorScheme.secondary,
        ),
      ],
    );
  }
}
