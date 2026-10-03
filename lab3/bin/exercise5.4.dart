/// Calculates a student's final grade based on three scores.
///
/// **Grade weights:**
/// - Assignments: 20%
/// - Midterm: 40%
/// - Final exam: 40%
///
/// The calculation used is:
///
/// ```dart
/// finalGrade = assignments * 0.20
///            + midterm * 0.40
///            + finalExam * 0.40;
/// ```
///
/// Example:
///
/// ```dart
/// double grade = calculateGrade(80, 75, 90);
/// print(grade);
/// ```
///
/// Returns the student's **weighted final grade**.
double calculateGrade(
  double assignments,
  double midterm,
  double finalExam,
) {
  return assignments * 0.20 +
      midterm * 0.40 +
      finalExam * 0.40;
}

void main() {
  double result = calculateGrade(80, 75, 90);

  print('Final grade: ${result.toStringAsFixed(2)}');
}