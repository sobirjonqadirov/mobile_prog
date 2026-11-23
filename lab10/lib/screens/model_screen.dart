
import 'package:flutter/material.dart';

import '../services/classifier.dart';

class ModelScreen extends StatelessWidget {
  const ModelScreen({
    super.key,
    required this.classifier,
  });

  final Classifier classifier;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Text(
          'Model Information',
          style: theme.textTheme.headlineMedium,
        ),
        const SizedBox(height: 16),
        Card(
          child: Column(
            children: [
              const ListTile(
                leading: Icon(Icons.memory),
                title: Text('Model file'),
                subtitle: Text('model_unquant.tflite'),
              ),
              ListTile(
                leading: const Icon(Icons.category_outlined),
                title: const Text('Number of classes'),
                subtitle: Text('${classifier.labels.length}'),
              ),
              ListTile(
                leading: const Icon(Icons.aspect_ratio),
                title: const Text('Input image size'),
                subtitle: Text(
                  '${Classifier.inputSize} × '
                  '${Classifier.inputSize}',
                ),
              ),
              const ListTile(
                leading: Icon(Icons.offline_bolt_outlined),
                title: Text('Inference'),
                subtitle: Text('On-device TensorFlow Lite'),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        Text(
          'Recognized Classes',
          style: theme.textTheme.titleLarge,
        ),
        const SizedBox(height: 12),
        Card(
          child: Column(
            children: [
              for (var i = 0;
                  i < classifier.labels.length;
                  i++)
                ListTile(
                  leading: CircleAvatar(
                    child: Text('${i + 1}'),
                  ),
                  title: Text(classifier.labels[i]),
                ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        Text(
          'Design Credit',
          style: theme.textTheme.titleLarge,
        ),
        const SizedBox(height: 12),
        const Card(
          child: ListTile(
            leading: Icon(Icons.palette_outlined),
            title: Text('Figma design reference'),
            subtitle: Text(
              'Designed by me '
              '1 hour before deadline',
            ),
          ),
        ),
      ],
    );
  }
}
