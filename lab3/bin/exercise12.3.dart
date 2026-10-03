void validateName(String? name) {
  if (name == null || name.isEmpty) {
    throw ArgumentError('Name cannot be null or empty.');
  }

  print('Valid name: $name');
}

void main() {
  validateName('Sobirjon');

  // validateName('');
  validateName(null);
}