Future<String> getUserData() async {
  await Future.delayed(Duration(seconds: 2));

  return 'User: Sobirjon, Age: 20';
}

void main() async {
  print('Looking up user...');

  String userData = await getUserData();

  print(userData);
}