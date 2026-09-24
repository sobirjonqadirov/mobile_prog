bool isEven(int n) => n % 2 == 0;

void main(List<String> arguments) {
  if (arguments.length != 1) {
    print('UsageError: Please provide exactly 1 argument.');
  } else if (int.tryParse(arguments[0]) == null) {
    print('TypeError: The argument must be an integer.');
  } else {
    int number = int.parse(arguments[0]);
    if (isEven(number)) {
      print('The provided number $number is even.');
    } else {
      print('The provided number $number is odd.');
    }
  }
}