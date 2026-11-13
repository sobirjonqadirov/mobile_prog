import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocktail/mocktail.dart';

import 'package:cart_four_ways/models/cart.dart';
import 'package:cart_four_ways/riverpod/cart_notifier.dart';
import 'package:cart_four_ways/services/checkout_api.dart';

class MockCheckoutApi extends Mock implements CheckoutApi {}

void main() {
  test('Adds keyboard twice and applies SAVE10', () {
    final container = ProviderContainer();

    final subscription = container.listen(
      cartProvider,
      (previous, next) {},
    );

    addTearDown(() {
      subscription.close();
      container.dispose();
    });

    final cart = container.read(cartProvider.notifier);

    cart.add(catalog[0]);
    cart.add(catalog[0]);
    cart.applyCoupon('SAVE10');

    final state = container.read(cartProvider);

    expect(state.itemCount, 2);
    expect(state.subtotal, 98);
    expect(state.discount, 9.8);
    expect(state.total, closeTo(88.2, 0.001));
    expect(state.coupon, 'SAVE10');
  });

  test('Checkout failure preserves cart items', () async {
    final mockApi = MockCheckoutApi();

    when(() => mockApi.submit(any())).thenThrow(
      const CheckoutException('Card declined'),
    );

    final container = ProviderContainer(
      overrides: [
        checkoutApiProvider.overrideWith((ref) => mockApi),
      ],
    );

    final subscription = container.listen(
      cartProvider,
      (previous, next) {},
    );

    addTearDown(() {
      subscription.close();
      container.dispose();
    });

    final cart = container.read(cartProvider.notifier);

    cart.add(catalog[0]);

    await cart.checkout();

    final state = container.read(cartProvider);

    expect(state.checkoutStatus, CheckoutStatus.failure);
    expect(state.checkoutError, 'Card declined');
    expect(state.lines, hasLength(1));
    expect(state.lines.first.product.id, 'p1');
  });
}