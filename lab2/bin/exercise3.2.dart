void main(List<String> arguments) {
  // Stopwatch stopwatch = Stopwatch()..start();

  if (arguments.length != 1) {
    print('UsageError: Please provide exactly 1 argument.');
  } else if (int.tryParse(arguments[0]) == null) {
    print('TypeError: The argument must be an integer.');
  } else if (int.parse(arguments[0]) < 0) {
    print('Provided number is negative.');
  } else if (int.parse(arguments[0]) == 0) {
    print('Provided number is zero.');
  } else {
    print('Provided number is positive.');
  }

  // print('\nProgram exited with code 0.');
  // stopwatch.stop();
  // print('Execution time: ${stopwatch.elapsedMicroseconds} μs');
}