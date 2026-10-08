import 'package:flutter/material.dart';

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: GalleryScreen(),
  ));
}

class GalleryScreen extends StatelessWidget {
  const GalleryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final images = List.generate(
      8,
      (index) => 'https://picsum.photos/seed/photo$index/800/800',
    );

    return Scaffold(
      appBar: AppBar(title: const Text('Photo Gallery')),
      body: GridView.count(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        padding: const EdgeInsets.all(12),
        children: images.map((imageUrl) {
          return GestureDetector(
            onTap: () {
              debugPrint('Opening photo: $imageUrl');
              Navigator.push(
                context,
                MaterialPageRoute<void>(
                  builder: (context) => PreviewScreen(imageUrl: imageUrl),
                ),
              );
            },
            child: Image.network(
              imageUrl,
              fit: BoxFit.cover,
            ),
          );
        }).toList(),
      ),
    );
  }
}

class PreviewScreen extends StatelessWidget {
  final String imageUrl;

  const PreviewScreen({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Photo Preview'),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      body: SizedBox.expand(
        child: Image.network(
          imageUrl,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}