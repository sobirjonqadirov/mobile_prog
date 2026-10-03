import 'dart:async';

void main() {
  int count = 0;

  late StreamSubscription<int> subscription;

  Stream<int> timerStream =
      Stream.periodic(Duration(seconds: 1), (value) => value + 1);

  subscription = timerStream.listen((tick) {
    print('Tick: $tick');
    count++;

    if (count == 5) {
      subscription.cancel();
      print('Subscription cancelled.');
    }
  });
}