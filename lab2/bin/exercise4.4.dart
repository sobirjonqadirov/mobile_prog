int digitSum(int n) {
  int sum = 0;
  while (n > 0) {
    sum += n % 10;
    n ~/= 10;
  }
  return sum;
}

int findHighest(
  List<int> numbers,
  int Function(int) transformer,
) {
  int bestNumber = numbers[0];
  int bestDigitSum = transformer(bestNumber);
  for (int number in numbers) {
    int currentDigitSum = transformer(number);
    if (currentDigitSum > bestDigitSum) {
      bestNumber = number;
      bestDigitSum = currentDigitSum;
    }
  }
  return bestNumber;
}

void main(List<String> arguments) {
  if (arguments.isEmpty) {
    print('UsageError: Please provide at least 1 argument.');
  } else if (arguments.any((arg) => int.tryParse(arg) == null)) {
    print('TypeError: All arguments must be integers.');
  } else {
    List<int> numbers = arguments.map(int.parse).toList();
    int highestNumber = findHighest(numbers, digitSum);
    print('The number with the highest digit sum is: $highestNumber');
  }
}