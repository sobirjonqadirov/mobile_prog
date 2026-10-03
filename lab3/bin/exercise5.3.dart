class Validator {
  /// Validates [age].
  /// Returns `true` if the age is valid.
  /// Throws [ArgumentError] if [age] is negative.
  static bool isValidAge(int age) {
    if (age < 0) {
      throw ArgumentError('Age cannot be negative.');
    }
    return age <= 120;
  }

  /// Validates [email].
  /// Returns `true` if the email format is valid.
  /// Throws [ArgumentError] if [email] is empty.
  static bool isValidEmail(String email) {
    if (email.isEmpty) {
      throw ArgumentError('Email cannot be empty.');
    }
    return email.contains('@') && email.contains('.');
  }
}

void main() {
  print(Validator.isValidAge(2255));
  print(Validator.isValidEmail('something@example.com'));
}