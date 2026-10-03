abstract interface class DayInfo {
  String getDisplayName();
  bool isWeekend();
}

enum Day implements DayInfo {
  monday,
  tuesday,
  wednesday,
  thursday,
  friday,
  saturday,
  sunday;

  @override
  String getDisplayName() {
    return switch (this) {
      Day.monday => 'Monday',
      Day.tuesday => 'Tuesday',
      Day.wednesday => 'Wednesday',
      Day.thursday => 'Thursday',
      Day.friday => 'Friday',
      Day.saturday => 'Saturday',
      Day.sunday => 'Sunday',
    };
  }

  @override
  bool isWeekend() {
    return this == Day.saturday || this == Day.sunday;
  }
}

void main() {
  for (Day day in Day.values) {
    print('${day.getDisplayName()} - Weekend: ${day.isWeekend()}');
  }
}