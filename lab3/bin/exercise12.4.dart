void testValue(String value) {
  try {
    int number = int.parse(value);

    if (number == 0) {
      throw UnsupportedError('Zero is not allowed.');
    }

    print('Number: $number');
  } on FormatException {
    print('Format exception: Input is not a valid integer.');
  } on UnsupportedError catch (e) {
    print('$e');
  } catch (e) {
    print('Other error: $e');
  }
}

void main() {
  testValue('25');
  testValue('hello');
  testValue('0');
}