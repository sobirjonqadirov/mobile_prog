void greet([String prefix = '', String suffix = '']) {
  print('Welcome to Dart world, $prefix Sobirjon $suffix!');
}

void main() {
  greet('Mr.', 'Jr.');
  greet('Dr.');
  greet();
}