class Person {
  String name;
  int age;

  Person(String name, int age)
      : assert(age >= 0 && age <= 120, 'Age must be between 0 and 120'),
        name = name,
        age = age;
}

void main() {
  Person person = Person('Sobirjon', 20);

  print('${person.name} is ${person.age} years old.');
}