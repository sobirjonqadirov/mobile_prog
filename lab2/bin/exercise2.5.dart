void main() {
  dynamic age = "19";
  if (age is String) {
    print(age.length);
    age = 19;
  } 
  if (age is int) {
    print('Age is int: $age');
    age = 19.5;
  }
  if (age is! int && age is! String) {
    print('Unsupported type: ${age.runtimeType}');
  }
}