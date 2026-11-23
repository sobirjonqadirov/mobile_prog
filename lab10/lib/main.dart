
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

import 'models/classification_record.dart';
import 'screens/history_screen.dart';
import 'screens/home_screen.dart';
import 'screens/model_screen.dart';
import 'screens/result_screen.dart';
import 'screens/welcome_screen.dart';
import 'services/classifier.dart';
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

  Classifier? _classifier;

  bool _loading = true;
  bool _entered = false;
  bool _previewBusy = false;

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
    _messengerKey.currentState
      ?..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(content: Text(message)),
      );
  }

  Future<void> _previewSample() async {
    if (_previewBusy || _classifier == null) return;

    setState(() {
      _previewBusy = true;
    });

    try {
      final data = await rootBundle.load(
        'assets/model/sample.png',
      );

      final bytes = data.buffer.asUint8List(
        data.offsetInBytes,
        data.lengthInBytes,
      );

      final predictions = _classifier!.classify(bytes);

      if (predictions.isEmpty) {
        throw StateError('The classifier returned no results.');
      }

      final record = ClassificationRecord(
        imageBytes: bytes,
        predictions: predictions,
        source: 'Sample',
        createdAt: DateTime.now(),
      );

      if (!mounted) return;

      setState(() {
        _history.insert(0, record);
      });

      _openResult(record);
    } catch (e) {
      if (mounted) {
        _showMessage('Could not classify sample: $e');
      }
    } finally {
      if (mounted) {
        setState(() {
          _previewBusy = false;
        });
      }
    }
  }

  void _openResult(ClassificationRecord record) {
    _navigatorKey.currentState?.push(
      MaterialPageRoute<void>(
        builder: (_) => ResultScreen(record: record),
      ),
    );
  }

  void _showComingSoon(String feature) {
    _showMessage(
      '$feature will be connected in Part 5.',
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
        onCamera: () => _showComingSoon('Camera'),
        onGallery: () => _showComingSoon('Gallery'),
        onDownload: () => _showComingSoon('Download'),
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
      body: SafeArea(
        child: IndexedStack(
          index: _selectedIndex,
          children: pages,
        ),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) {
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
