import 'dart:io';

void main() {
  stdout.write("Choose a temperature measurement you want to enter (1 for Celsius, 2 for Fahrenheit): ");
  String? input = stdin.readLineSync();
  if (input != null) {
    int choice = int.parse(input);
    stdout.write("Enter the temperature value: ");
    String? tempInput = stdin.readLineSync();
    if (tempInput != null) {
      double temperature = double.parse(tempInput);
      if (choice == 1) {
        double fahrenheit = (temperature * 9/5) + 32;   // Celsius to Fahrenheit conversion formula
        /* This formula takes the temperature in Celsius and converts it 
        to Fahrenheit by multiplying it by 9/5 and adding 32 */
        print("$temperature °C is equal to $fahrenheit °F.");
      } else if (choice == 2) {
        double celsius = (temperature - 32) * 5/9;      // Fahrenheit to Celsius conversion formula
        /* This formula takes the temperature in Fahrenheit and converts it 
        to Celsius by subtracting 32 and multiplying by 5/9 */
        print("$temperature °F is equal to $celsius °C.");
      } else {
        print("Invalid choice. Please enter 1 or 2.");
      }
    } else {
      print("No temperature input provided.");
    }
  } else {
    print("No input provided.");
  }
}