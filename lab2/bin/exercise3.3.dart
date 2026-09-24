void main(List<String> arguments) {
  if (arguments.length != 1) {
    print('UsageError: Please provide exactly 1 argument.');
  } else if (int.tryParse(arguments[0]) == null) {
    print('TypeError: The argument must be an integer.');
  } else if (int.parse(arguments[0]) < 0) {
    print('Provided number is negative.');
  } else if (int.parse(arguments[0]) == 0) {
    print('Provided number is zero.');
  } else {
    int number = int.parse(arguments[0]);
    Stopwatch stopwatch1 = Stopwatch()..start();
    int factorial1 = 1;

    for (int i = 1; i <= number; i++) {
      factorial1 *= i;
    }
    stopwatch1.stop();
    print('For loop:\nFactorial of $number is: $factorial1');
    print('Execution time: ${stopwatch1.elapsedMicroseconds} μs');

    Stopwatch stopwatch2 = Stopwatch()..start();
    int factorial2 = 1;
    var numbers = List.generate(number, (index) => index + 1);

    for (int i in numbers) {
      factorial2 *= i;
    }
    stopwatch2.stop();
    print('For in loop:\nFactorial of $number is: $factorial2');
    print('Execution time: ${stopwatch2.elapsedMicroseconds} μs');
  }
}