
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

import 'models/classification_record.dart';
import 'screens/history_screen.dart';
import 'screens/home_screen.dart';
import 'screens/model_screen.dart';
import 'screens/result_screen.dart';
import 'screens/welcome_screen.dart';
import 'services/classifier.dart';
import 'services/image_sources.dart';
import 'theme/app_theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ObjectLensApp());
}

class ObjectLensApp extends StatefulWidget {
  const ObjectLensApp({super.key});

  @override
  State<ObjectLensApp> createState() => _ObjectLensAppState();
}

class _ObjectLensAppState extends State<ObjectLensApp> {
  final _navigatorKey = GlobalKey<NavigatorState>();
  final _messengerKey = GlobalKey<ScaffoldMessengerState>();

  final ImageSources _sources = ImageSources();

  Classifier? _classifier;

  bool _loading = true;
  bool _entered = false;
  bool _isProcessing = false;

  String? _error;
  int _selectedIndex = 0;

  final List<ClassificationRecord> _history = [];

  @override
  void initState() {
    super.initState();
    _loadClassifier();
  }

  Future<void> _loadClassifier() async {
    try {
      final classifier = await Classifier.load();

      if (!mounted) {
        classifier.close();
        return;
      }

      setState(() {
        _classifier = classifier;
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _loading = false;
        _error = 'Unable to load the classifier.\n'
            'Check assets/model/model_unquant.tflite '
            'and assets/model/labels.txt.\n\n$e';
      });
    }
  }

  void _showMessage(String message) {
    final messenger = _messengerKey.currentState;

    messenger?.hideCurrentSnackBar();
    messenger?.showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 5),
      ),
    );
  }

  Future<void> _classifyFrom({
    required Future<Uint8List?> Function() getBytes,
    required String source,
  }) async {
    if (_isProcessing || _classifier == null) return;

    setState(() {
      _isProcessing = true;
    });

    try {
      final bytes = await getBytes();

      if (!mounted || bytes == null) return;

      final stopwatch = Stopwatch()..start();

      final predictions = _classifier!.classify(bytes);

      stopwatch.stop();

      debugPrint(
        '$source classification took '
        '${stopwatch.elapsedMilliseconds} ms',
      );

      if (predictions.isEmpty) {
        throw StateError(
          'The classifier returned no predictions.',
        );
      }

      final record = ClassificationRecord(
        imageBytes: bytes,
        predictions: predictions,
        source: source,
        createdAt: DateTime.now(),
      );

      if (!mounted) return;

      setState(() {
        _history.insert(0, record);
      });

      _openResult(record);
    } catch (e) {
      if (mounted) {
        _showMessage(
          'Could not classify $source image: $e',
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isProcessing = false;
        });
      }
    }
  }

  Future<void> _previewSample() async {
    await _classifyFrom(
      source: 'Sample',
      getBytes: () async {
        final data = await rootBundle.load(
          'assets/model/sample.png',
        );

        return data.buffer.asUint8List(
          data.offsetInBytes,
          data.lengthInBytes,
        );
      },
    );
  }

  Future<void> _takePhoto() async {
    await _classifyFrom(
      source: 'Camera',
      getBytes: _sources.fromCamera,
    );
  }

  Future<void> _chooseGallery() async {
    await _classifyFrom(
      source: 'Gallery',
      getBytes: _sources.fromGallery,
    );
  }

  Future<void> _downloadImage() async {
    if (_isProcessing) return;

    final navigatorContext = _navigatorKey.currentContext;
    if (navigatorContext == null) return;

    String enteredUrl = '';

    final url = await showDialog<String>(
      context: navigatorContext,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Download an image'),
          content: TextField(
            autofocus: true,
            keyboardType: TextInputType.url,
            decoration: const InputDecoration(
              labelText: 'Image URL',
              hintText: 'https://example.com/image.png',
              border: OutlineInputBorder(),
            ),
            onChanged: (value) {
              enteredUrl = value;
            },
            onSubmitted: (value) {
              Navigator.of(dialogContext).pop(value.trim());
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () {
                Navigator.of(
                  dialogContext,
                ).pop(enteredUrl.trim());
              },
              child: const Text('Download'),
            ),
          ],
        );
      },
    );

    if (!mounted || url == null) return;

    await _classifyFrom(
      source: 'Download',
      getBytes: () => _sources.fromUrl(url),
    );
  }

  void _openResult(ClassificationRecord record) {
    _navigatorKey.currentState?.push(
      MaterialPageRoute<void>(
        builder: (_) => ResultScreen(record: record),
      ),
    );
  }

  @override
  void dispose() {
    _classifier?.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ObjectLens',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      navigatorKey: _navigatorKey,
      scaffoldMessengerKey: _messengerKey,
      home: !_entered
          ? WelcomeScreen(
              labels: _classifier?.labels ?? [],
              loading: _loading,
              error: _error,
              onStart: () {
                setState(() {
                  _entered = true;
                });
              },
            )
          : _buildMainShell(),
    );
  }

  Widget _buildMainShell() {
    final classifier = _classifier!;

    final pages = [
      HomeScreen(
        onPreview: _previewSample,
        onCamera: _takePhoto,
        onGallery: _chooseGallery,
        onDownload: _downloadImage,
        latest: _history.isEmpty ? null : _history.first,
        onOpenLatest: () {
          if (_history.isNotEmpty) {
            _openResult(_history.first);
          }
        },
      ),
      HistoryScreen(
        records: _history,
        onOpenRecord: _openResult,
      ),
      ModelScreen(classifier: classifier),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('ObjectLens'),
      ),
      body: Stack(
        children: [
          SafeArea(
            child: IndexedStack(
              index: _selectedIndex,
              children: pages,
            ),
          ),
          if (_isProcessing)
            Positioned.fill(
              child: ColoredBox(
                color: Colors.black54,
                child: Center(
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(28),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const CircularProgressIndicator(),
                          const SizedBox(height: 20),
                          Text(
                            'Processing image...',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) {
          if (_isProcessing) return;

          setState(() {
            _selectedIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.history),
            label: 'History',
          ),
          NavigationDestination(
            icon: Icon(Icons.memory_outlined),
            selectedIcon: Icon(Icons.memory),
            label: 'Model',
          ),
        ],
      ),
    );
  }
}
