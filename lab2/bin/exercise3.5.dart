void main() {
  var baskets = [
    ['apple', 'banana', 'orange'],
    ['apple', 'rotten', 'banana'],
    ['apple', 'grape', 'stop'],
    ['mango', 'pear']
  ];

  basketLoop:
  for (var basket in baskets) {
    print('Checking new basket...');

    for (var fruit in basket) {
      if (fruit == 'rotten') {
        print('Rotten fruit found. Skip this basket.\n');
        continue basketLoop;
      }

      if (fruit == 'stop') {
        print('Stop fruit found. End inspection.');
        break basketLoop;
      }

      print('Fruit: $fruit');
    }

    print('Basket is okay.\n');
  }
}