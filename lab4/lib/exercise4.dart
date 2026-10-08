import 'package:flutter/material.dart';

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: IndicatorScreen(),
  ));
}

class IndicatorScreen extends StatefulWidget {
  const IndicatorScreen({super.key});

  @override
  State<IndicatorScreen> createState() => _IndicatorScreenState();
}

class _IndicatorScreenState extends State<IndicatorScreen> {
  bool _isLoading = false;

  Future<void> _startOperation() async {
    setState(() {
      _isLoading = true;
    });

    await Future<void>.delayed(const Duration(seconds: 3));

    if (!mounted) return;

    setState(() {
      _isLoading = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Money has been transferred to the scammer'),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            debugPrint('Undo pressed');
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Indicators & Feedback'),
      ),
      body: Center(
        child: _isLoading
            ? const CircularProgressIndicator()
            : ElevatedButton(
                onPressed: _startOperation,
                child: const Text('Press this to lose your money in your bank account'),
              ),
      ),
    );
  }
}