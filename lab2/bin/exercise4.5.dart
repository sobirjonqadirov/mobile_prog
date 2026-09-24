int fibonacci(int n) {
  if (n == 0) {
    return 0;
  } else if (n == 1) {
    return 1;
  } else {
    return fibonacci(n - 1) + fibonacci(n - 2);
  }
}

void main(List<String> arguments) {
  if (arguments.length != 1) {
    print('UsageError: Please provide at least 1 argument.');
  } else if (int.tryParse(arguments[0]) == null) {
    print('TypeError: The argument must be an integer.');
  } else if (int.parse(arguments[0]) < 0) {
    print('Provided number is negative.');
  } else {
    int n = int.parse(arguments[0]);
    int result = fibonacci(n);
    print('Fibonacci of $n is $result.');
  }
}