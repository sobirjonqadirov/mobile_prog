import 'package:flutter/material.dart';

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: DialogScreen(),
  ));
}

class DialogScreen extends StatefulWidget {
  const DialogScreen({super.key});

  @override
  State<DialogScreen> createState() => _DialogScreenState();
}

class _DialogScreenState extends State<DialogScreen> {
  bool _itemExists = true;

  Future<void> _confirmDelete() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete item?'),
        content: const Text('Are you sure you want to delete this item?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext, false);
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext, true);
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (!mounted) return;

    if (confirmed == true) {
      setState(() {
        _itemExists = false;
      });
      debugPrint('Item deleted');
    }
  }

  void _showShareOptions() {
    showModalBottomSheet<void>(
      context: context,
      builder: (sheetContext) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.email),
              title: const Text('Email'),
              onTap: () {
                Navigator.pop(sheetContext);
                debugPrint('Share via Email selected');
              },
            ),
            ListTile(
              leading: const Icon(Icons.message),
              title: const Text('Message'),
              onTap: () {
                Navigator.pop(sheetContext);
                debugPrint('Share via Message selected');
              },
            ),
            ListTile(
              leading: const Icon(Icons.link),
              title: const Text('Copy link'),
              onTap: () {
                Navigator.pop(sheetContext);
                debugPrint('Copy link selected');
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dialogs & Modals'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(_itemExists ? 'Share this urgent news' : 'News deleted'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _itemExists ? _confirmDelete : null,
              child: const Text('Delete the news'),
            ),
            const SizedBox(height: 12),
            OutlinedButton(
              onPressed: _itemExists ? _showShareOptions : null,
              child: const Text('Share'),
            ),
          ],
        ),
      ),
    );
  }
}