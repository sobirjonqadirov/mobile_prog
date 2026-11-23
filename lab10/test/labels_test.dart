
import 'package:flutter_test/flutter_test.dart';
import '../lib/services/classifier.dart';

void main() {
  group('parseLabels', () {
    test('parses normal labels', () {
      const input = '0 Mug\n1 Bottle\n';

      final result = parseLabels(input);

      expect(result, ['Mug', 'Bottle']);
    });

    test('handles Windows line endings and spaces', () {
      const input =
          '0 Mug\r\n'
          '1 Bottle\r\n'
          '2 Car keys\r\n'
          '\r\n';

      final result = parseLabels(input);

      expect(result, [
        'Mug',
        'Bottle',
        'Car keys',
      ]);
    });
  });
}
