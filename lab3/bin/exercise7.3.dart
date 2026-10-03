enum Day {
  monday,
  tuesday,
  wednesday,
  thursday,
  friday,
  saturday,
  sunday
}

String getDisplayName(Day day) {
  return switch (day) {
    Day.monday => 'Monday',
    Day.tuesday => 'Tuesday',
    Day.wednesday => 'Wednesday',
    Day.thursday => 'Thursday',
    Day.friday => 'Friday',
    Day.saturday => 'Saturday',
    Day.sunday => 'Sunday',
  };
}

void main() {
  for (Day day in Day.values) {
    print(getDisplayName(day));
  }
}