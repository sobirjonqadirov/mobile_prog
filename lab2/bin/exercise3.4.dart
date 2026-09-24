import 'dart:io';
import 'dart:math';

void main() {
  int target = Random().nextInt(10) + 1;

  while(true) {
    stdout.write('Guess a number between 1 and 10: ');
    String? input = stdin.readLineSync();
    int? guess = int.tryParse(input ?? '');
    if (guess == null) {
      print('Invalid input. Please enter a valid number.');
      continue;
    }

    if (guess < 1 || guess > 10) {
      print('Please guess a number between 1 and 10.');
      continue;
    }

    if (guess < target) {
      print('Too low! Try again.');
    } else if (guess > target) {
      print('Too high! Try again.');
    } else {
      print('Congratulations! You guessed the correct number: $target');
      break;
    }
  }
}