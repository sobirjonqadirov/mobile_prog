class Shape {
  void describe() {
    print('This is a shape.');
  }
}

class Polygon extends Shape {
  void sides() {
    print('A polygon has multiple sides.');
  }
}

class Triangle extends Polygon {
  void triangleInfo() {
    print('A triangle has 3 sides.');
  }
}

void main() {
  Triangle triangle = Triangle();

  triangle.describe();
  triangle.sides();
  triangle.triangleInfo();
}