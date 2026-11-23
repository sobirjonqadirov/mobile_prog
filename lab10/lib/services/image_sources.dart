
import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class ImageSourceException implements Exception {
  const ImageSourceException(this.message);

  final String message;

  @override
  String toString() => message;
}

class ImageSources {
  final ImagePicker _picker = ImagePicker();

  Future<Uint8List?> fromCamera() async {
    try {
      final shot = await _picker.pickImage(
        source: ImageSource.camera,
        maxWidth: 1024,
      );

      if (shot == null) return null;

      return await shot.readAsBytes();
    } on PlatformException catch (e) {
      throw ImageSourceException(
        'Could not open the camera. '
        'Check camera access and device availability. '
        '${e.message ?? ''}',
      );
    }
  }

  Future<Uint8List?> fromGallery() async {
    try {
      final picture = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1024,
      );

      if (picture == null) return null;

      return await picture.readAsBytes();
    } on PlatformException catch (e) {
      throw ImageSourceException(
        'Could not open the gallery. '
        'Please check photo access. '
        '${e.message ?? ''}',
      );
    }
  }

  Future<Uint8List> fromUrl(String url) async {
    final uri = Uri.tryParse(url.trim());

    if (uri == null ||
        (uri.scheme != 'http' && uri.scheme != 'https') ||
        uri.host.isEmpty) {
      throw const ImageSourceException(
        'Please enter a valid HTTP or HTTPS image URL.',
      );
    }

    try {
      final response = await http
          .get(uri)
          .timeout(const Duration(seconds: 15));

      if (response.statusCode != 200) {
        throw ImageSourceException(
          'Download failed with HTTP status '
          '${response.statusCode}.',
        );
      }

      final contentType =
          response.headers['content-type']?.toLowerCase() ?? '';

      if (!contentType.startsWith('image/')) {
        throw const ImageSourceException(
          'This URL does not point to an image.',
        );
      }

      if (response.bodyBytes.isEmpty) {
        throw const ImageSourceException(
          'The downloaded image is empty.',
        );
      }

      return response.bodyBytes;
    } on TimeoutException {
      throw const ImageSourceException(
        'Download timed out. Please try again.',
      );
    } on SocketException {
      throw const ImageSourceException(
        'No internet connection. Check your network.',
      );
    } on http.ClientException {
      throw const ImageSourceException(
        'Network request failed. Check the image URL.',
      );
    }
  }
}
