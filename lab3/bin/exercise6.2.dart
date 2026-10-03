class Person {
  String name;
  int age;

  Person(this.name, this.age);
}

void main() {
  Person person1 = Person('Sobirjon', 20);

  print('Name: ${person1.name}');
  print('Age: ${person1.age}');
}