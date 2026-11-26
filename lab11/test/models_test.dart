import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:lab11/models/product.dart';

void main() {
  test('Product parses JSON fixture correctly', () {
    final json = jsonDecode(
      File('test/fixtures/product.json').readAsStringSync(),
    ) as Map<String, dynamic>;

    final product = Product.fromJson(json);

    expect(product.title, 'Essence Mascara Lash Princess');
    expect(product.price, isA<double>());
    expect(product.tags.length, 2);
    expect(product.reviews.length, 3);
  });

  test('Product handles missing brand and tags', () {
    final product = Product.fromJson({
      'id': 1,
      'title': 'Test Product',
      'price': 10,
      'rating': 4,
      'thumbnail': '',
      'description': 'Test description',
      'images': [],
      'dimensions': {'width': 10, 'height': 20, 'depth': 5},
      'reviews': [],
    });

    expect(product.brand, isNull);
    expect(product.tags, isEmpty);
    expect(product.price, 10.0);
  });
}
