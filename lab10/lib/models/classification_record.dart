
import 'dart:typed_data';

import '../services/classifier.dart';

class ClassificationRecord {
  ClassificationRecord({
    required this.imageBytes,
    required this.predictions,
    required this.source,
    required this.createdAt,
  });

  final Uint8List imageBytes;
  final List<Prediction> predictions;
  final String source;
  final DateTime createdAt;

  Prediction get topPrediction => predictions.first;
}
