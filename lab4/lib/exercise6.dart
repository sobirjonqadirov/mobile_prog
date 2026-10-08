import 'package:flutter/material.dart';

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: VolumeScreen(),
  ));
}

class VolumeScreen extends StatefulWidget {
  const VolumeScreen({super.key});

  @override
  State<VolumeScreen> createState() => _VolumeScreenState();
}

class _VolumeScreenState extends State<VolumeScreen> {
  double _volume = 50;
  DateTime? _selectedDate;

  String _formatDate(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    return '$day/$month/${date.year}';
  }

  Future<void> _pickDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100, 12, 31),
    );

    if (!mounted || date == null) return;

    setState(() {
      _selectedDate = date;
    });
    debugPrint('Selected date: ${_formatDate(date)}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Volume & Date')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Volume: ${_volume.round()}%',
              style: const TextStyle(fontSize: 24),
            ),
            Slider(
              value: _volume,
              min: 0,
              max: 100,
              divisions: 100,
              label: '${_volume.round()}%',
              onChanged: (value) {
                setState(() {
                  _volume = value;
                });
              },
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _pickDate,
              child: const Text('Choose date'),
            ),
            const SizedBox(height: 12),
            Text(
              _selectedDate == null
                  ? 'No date selected'
                  : 'Date: ${_formatDate(_selectedDate!)}',
            ),
          ],
        ),
      ),
    );
  }
}