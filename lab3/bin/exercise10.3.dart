class GameItem {
  String name;

  GameItem(this.name);
}

class Weapon extends GameItem {
  int damage;

  Weapon(super.name, this.damage);
}

class Potion extends GameItem {
  int healing;

  Potion(super.name, this.healing);
}

void main() {
  List<GameItem> inventory = [
    Weapon('Iron Sword', 25),
    Potion('Health Potion', 40),
    Weapon('Magic Bow', 35),
  ];

  for (GameItem item in inventory) {
    if (item is Weapon) {
      print('${item.name} is a weapon with ${item.damage} damage.');
    } else if (item is Potion) {
      print('${item.name} restores ${item.healing} health.');
    }
  }
}