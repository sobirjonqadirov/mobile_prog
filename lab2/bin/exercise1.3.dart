void main(List<String> arguments) {
  print('Hello, Dart World!');
  if (arguments.isNotEmpty) {
    print('Command line arguments passed: ${arguments.join(', ')}');
    print('Number of arguments: ${arguments.length}');
  }
}