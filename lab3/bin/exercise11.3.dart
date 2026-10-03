Future<String> getUser() async {
  await Future.delayed(Duration(seconds: 2));
  return 'User loaded';
}

Future<String> getOrders() async {
  await Future.delayed(Duration(seconds: 1));
  return 'Orders loaded';
}

Future<String> getMessages() async {
  await Future.delayed(Duration(seconds: 3));
  return 'Messages loaded';
}

void main() async {
  print('Starting tasks...');

  List<String> results = await Future.wait([
    getUser(),
    getOrders(),
    getMessages(),
  ]);

  print(results);
}