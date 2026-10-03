enum Day {
  monday,
  tuesday,
  wednesday,
  thursday,
  friday,
  saturday,
  sunday
}

void main() {
  for (Day day in Day.values) {
    print(day.name);
  }
}