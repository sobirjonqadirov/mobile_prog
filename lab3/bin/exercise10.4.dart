class Repository<T> {
  List<T> items = [];

  void add(T item) {
    items.add(item);
  }

  void showAll() {
    for (T item in items) {
      print(item);
    }
  }
}

void main() {
  Repository<String> names = Repository<String>();
  names.add('Azamat');
  names.add('Sobirjon');

  Repository<int> numbers = Repository<int>();
  numbers.add(10);
  numbers.add(20);

  names.showAll();
  numbers.showAll();
}