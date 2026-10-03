class Car {
  String brand;

  Car(this.brand);
}

class ElectricCar extends Car {
  ElectricCar(super.brand);
}

void main() {
  ElectricCar car = ElectricCar('Tesla');

  print(car.brand);
}