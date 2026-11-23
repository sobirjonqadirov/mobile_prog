
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

import 'services/classifier.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Classifier? _classifier;
  bool _loading = true;
  String? _error;

  List<Prediction> _predictions = [];

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    Classifier? classifier;

    try {
      classifier = await Classifier.load();

      if (!mounted) {
        classifier.close();
        return;
      }

      setState(() {
        _classifier = classifier;
        _loading = false;
      });

      await _classifySample();
    } catch (e) {
      if (classifier != null &&
          !identical(classifier, _classifier)) {
        classifier.close();
      }

      if (!mounted) return;

      setState(() {
        _loading = false;
        _error = 'Could not load the model.\n'
            'Expected: assets/model/model_unquant.tflite '
            'and assets/model/labels.txt\n\n$e';
      });
    }
  }

  Future<void> _classifySample() async {
    final classifier = _classifier;
    if (classifier == null) return;

    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final data = await rootBundle.load(
        'assets/model/sample.png',
      );

      final bytes = data.buffer.asUint8List(
        data.offsetInBytes,
        data.lengthInBytes,
      );

      final predictions = classifier.classify(bytes);

      for (final prediction in predictions) {
        debugPrint(
          '${prediction.label}: '
          '${(prediction.confidence * 100).toStringAsFixed(1)}%',
        );
      }

      final total = predictions.fold<double>(
        0.0,
        (sum, prediction) => sum + prediction.confidence,
      );

      debugPrint('Total confidence: $total');

      if (!mounted) return;

      setState(() {
        _predictions = predictions;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _error = 'Could not classify sample.jpg:\n$e';
      });
    } finally {
      if (mounted) {
        setState(() {
          _loading = false;
        });
      }
    }
  }

  void _testInvalidImage() {
    final classifier = _classifier;
    if (classifier == null) return;

    try {
      final invalidBytes = Uint8List.fromList(
        'This is not an image'.codeUnits,
      );

      classifier.classify(invalidBytes);
    } catch (e) {
      setState(() {
        _error = 'Invalid image: $e';
      });
    }
  }

  @override
  void dispose() {
    _classifier?.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Teachable Machine Classifier',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.teal,
        ),
        useMaterial3: true,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Image Classifier'),
        ),
        body: Center(
          child: _loading
              ? const CircularProgressIndicator()
              : _error != null
                  ? Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.error_outline,
                            size: 48,
                            color: Colors.red,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            _error!,
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 20),
                          if (_classifier != null)
                            ElevatedButton(
                              onPressed: _classifySample,
                              child: const Text('Try Again'),
                            ),
                        ],
                      ),
                    )
                  : ListView(
                      padding: const EdgeInsets.all(20),
                      children: [
                        const Text(
                          'Classification Results',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 20),
                        for (final prediction in _predictions)
                          Padding(
                            padding: const EdgeInsets.only(
                              bottom: 16,
                            ),
                            child: Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${prediction.label}: '
                                  '${(prediction.confidence * 100).toStringAsFixed(1)}%',
                                ),
                                const SizedBox(height: 6),
                                LinearProgressIndicator(
                                  value: prediction.confidence
                                      .clamp(0.0, 1.0),
                                ),
                              ],
                            ),
                          ),
                        const SizedBox(height: 24),
                        ElevatedButton(
                          onPressed: _testInvalidImage,
                          child: const Text(
                            'Test Invalid Image',
                          ),
                        ),
                      ],
                    ),
        ),
      ),
    );
  }
}
