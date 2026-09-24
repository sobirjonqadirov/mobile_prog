void main() {
  // String name;
  // print(name);
  // When the code above is run, it will throw this error:
  // bin/exercise2.4.dart:3:9: Error: Non-nullable variable 'name' must be assigned before it can be used.
  //   print(name);
  //         ^^^^
  String fullname = 'Qadirov Sobirjon';
  String? country = null ?? 'unknown';
  print('Full name: $fullname\nCountry: $country');
  country = 'Uzbekistan';
  print('Full name: $fullname\nCountry: $country');
}