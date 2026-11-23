
import 'dart:typed_data';

import 'package:flutter/services.dart' show rootBundle;
import 'package:image/image.dart' as img;
import 'package:tflite_flutter/tflite_flutter.dart';

class Prediction {
  const Prediction(this.label, this.confidence);

  final String label;
  final double confidence;
}

List<String> parseLabels(String raw) => [
      for (final line in raw.split('\n'))
        if (line.trim().isNotEmpty)
          line.trim().replaceFirst(RegExp(r'^\d+\s+'), ''),
    ];

class Classifier {
  Classifier._(this._interpreter, this.labels);

  final Interpreter _interpreter;
  final List<String> labels;

  static const int inputSize = 224;

  static Future<Classifier> load() async {
    final interpreter = await Interpreter.fromAsset(
      'assets/model/model_unquant.tflite',
    );

    try {
      final labels = parseLabels(
        await rootBundle.loadString('assets/model/labels.txt'),
      );

      final inputShape = interpreter.getInputTensor(0).shape;
      final outputShape = interpreter.getOutputTensor(0).shape;

      if (inputShape.length != 4 ||
          inputShape[0] != 1 ||
          inputShape[1] != inputSize ||
          inputShape[2] != inputSize ||
          inputShape[3] != 3 ||
          outputShape.length != 2 ||
          outputShape[0] != 1 ||
          outputShape[1] != labels.length) {
        throw StateError(
          'Model dimensions do not match the expected '
          '224x224 RGB input and ${labels.length} labels.',
        );
      }

      return Classifier._(interpreter, labels);
    } catch (_) {
      interpreter.close();
      rethrow;
    }
  }

  List<Prediction> classify(Uint8List bytes) {
    final decoded = img.decodeImage(bytes);

    if (decoded == null) {
      throw const FormatException('Not a readable image');
    }

    final oriented = img.bakeOrientation(decoded);

    final square = img.copyResizeCropSquare(
      oriented,
      size: inputSize,
    );

    final input = [
      List.generate(
        inputSize,
        (y) => List.generate(inputSize, (x) {
          final pixel = square.getPixel(x, y);

          return [
            pixel.r / 127.5 - 1,
            pixel.g / 127.5 - 1,
            pixel.b / 127.5 - 1,
          ];
        }),
      ),
    ];

    final output = [
      List<double>.filled(labels.length, 0.0),
    ];

    _interpreter.run(input, output);

    final predictions = [
      for (var i = 0; i < labels.length; i++)
        Prediction(labels[i], output.first[i]),
    ];

    predictions.sort(
      (a, b) => b.confidence.compareTo(a.confidence),
    );

    return predictions;
  }

  void close() {
    _interpreter.close();
  }
}
