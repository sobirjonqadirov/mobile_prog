import 'package:flutter/material.dart';

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: PlaylistScreen(),
  ));
}

class PlaylistScreen extends StatefulWidget {
  const PlaylistScreen({super.key});

  @override
  State<PlaylistScreen> createState() => _PlaylistScreenState();
}

class _PlaylistScreenState extends State<PlaylistScreen> {
  final List<String> _songs = List.generate(
    20,
    (index) => 'Track ${index + 1}',
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Playlist')),
      body: _songs.isEmpty
          ? const Center(child: Text('Playlist empty'))
          : ListView.builder(
              itemCount: _songs.length,
              itemBuilder: (context, index) {
                final song = _songs[index];

                return Dismissible(
                  key: ValueKey(song),
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  secondaryBackground: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  onDismissed: (direction) {
                    setState(() {
                      _songs.remove(song);
                    });
                    debugPrint('$song removed');
                  },
                  child: ListTile(
                    leading: const Icon(Icons.music_note),
                    title: Text(song),
                    subtitle: const Text('Swipe to remove'),
                  ),
                );
              },
            ),
    );
  }
}