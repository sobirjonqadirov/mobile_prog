import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/cart.dart';
import '../services/checkout_api.dart';

final checkoutApiProvider = Provider<CheckoutApi>(
  (ref) => CheckoutApi(),
);

class CartNotifier extends Notifier<CartState> {
  final List<CartState> _history = [];

  bool get canUndo => _history.isNotEmpty;

  @override
  CartState build() => const CartState();

  void add(Product product) {
    final nextState = state.copyWith(
      lines: state.lines.withProduct(product),
    );

    _saveHistoryIfChanged(nextState);
    state = nextState;
  }

  void changeQty(String id, int delta) {
    final nextState = state.copyWith(
      lines: state.lines.changeQty(id, delta),
    );

    _saveHistoryIfChanged(nextState);
    state = nextState;
  }

  void applyCoupon(String code) {
    final nextState = code.trim() == 'SAVE10'
        ? state.copyWith(
            coupon: 'SAVE10',
            clearCouponError: true,
          )
        : state.copyWith(
            clearCoupon: true,
            couponError: 'Invalid coupon code',
          );

    _saveHistoryIfChanged(nextState);
    state = nextState;
  }

  void _saveHistoryIfChanged(CartState nextState) {
    if (nextState != state) {
      _history.add(state);
    }
  }

  void undo() {
    if (_history.isEmpty) return;

    state = _history.removeLast();
  }

  Future<void> checkout() async {
    if (state.lines.isEmpty ||
        state.checkoutStatus == CheckoutStatus.submitting) {
      return;
    }

    final total = state.total;
    final previousState = state;

    state = state.copyWith(
      checkoutStatus: CheckoutStatus.submitting,
      clearCheckoutError: true,
    );

    try {
      final orderId = await ref.read(checkoutApiProvider).submit(total);

      _history.add(
        previousState.copyWith(
          checkoutStatus: CheckoutStatus.idle,
          clearCheckoutError: true,
        ),
      );

      state = state.copyWith(
        lines: const [],
        clearCoupon: true,
        checkoutStatus: CheckoutStatus.success,
        orderId: orderId,
        clearCheckoutError: true,
      );
    } on CheckoutException catch (e) {
      state = state.copyWith(
        checkoutStatus: CheckoutStatus.failure,
        checkoutError: e.message,
      );
    }
  }

  void clearCheckoutError() {
    state = state.copyWith(
      checkoutStatus: CheckoutStatus.idle,
      clearCheckoutError: true,
    );
  }
}

final cartProvider =
    NotifierProvider.autoDispose<CartNotifier, CartState>(
  CartNotifier.new,
);

final canUndoProvider = Provider.autoDispose<bool>((ref) {
  ref.watch(cartProvider);

  return ref.read(cartProvider.notifier).canUndo;
});