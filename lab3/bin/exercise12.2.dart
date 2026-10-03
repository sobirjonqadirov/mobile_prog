double divide(double a, double b) {
  try {
    if (b == 0) {
      throw UnsupportedError('Division by zero is not supported.');
    }

    return a / b;
  } on UnsupportedError catch (e) {
    print('Error: $e');
    return double.nan;
  }
}

void main() {
  print(divide(10, 2));
  print(divide(10, 0));
}