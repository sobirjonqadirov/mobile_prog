void main() {
  final date1 = DateTime.now();
  print('Current date and time: $date1');

  // const date2 = DateTime.now();
  // print('Current date and time: $date2');

  // When you run the above code, you will get an error message like this:

  // dart run bin/exercise2.3.dart
  // bin/exercise2.3.dart:5:26: Error: Cannot invoke a non-'const' constructor where a const expression is expected.
  // Try using a constructor or factory that is 'const'.
  //   const date2 = DateTime.now();
  //                         ^^^
}