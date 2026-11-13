import 'package:flutter/material.dart';
import '../models/cart.dart';
import '../services/checkout_api.dart';
import '../widgets/cart_body.dart';

class SetStateCartPage extends StatefulWidget {
  const SetStateCartPage({super.key});

  @override
  State<SetStateCartPage> createState() => _SetStateCartPageState();
}

class _SetStateCartPageState extends State<SetStateCartPage> {
  CartState _state = const CartState();

  final CheckoutApi _checkoutApi = CheckoutApi();
  final List<CartState> _history = [];

  void _undo() {
    if (_history.isEmpty) return;

    setState(() {
      _state = _history.removeLast();
    });
  }

  void _add(Product p) {
    setState(() {
      _history.add(_state);

      _state = _state.copyWith(
        lines: _state.lines.withProduct(p),
      );
    });
  }

  void _changeQty(String id, int delta) {
    setState(() {
      _history.add(_state);

      _state = _state.copyWith(
        lines: _state.lines.changeQty(id, delta),
      );
    });
  }

  void _applyCoupon(String code) {
    setState(() {
      _history.add(_state);

      if (code.trim() == 'SAVE10') {
        _state = _state.copyWith(
          coupon: 'SAVE10',
          clearCouponError: true,
        );
      } else {
        _state = _state.copyWith(
          clearCoupon: true,
          couponError: 'Invalid coupon code',
        );
      }
    });
  }

  Future<void> _checkout() async {
    if (_state.lines.isEmpty ||
        _state.checkoutStatus == CheckoutStatus.submitting) {
      return;
    }

    setState(() {
      _state = _state.copyWith(
        checkoutStatus: CheckoutStatus.submitting,
        clearCheckoutError: true,
      );
    });

    try {
      final orderId = await _checkoutApi.submit(_state.total);

      if (!mounted) return;

      setState(() {
        _state = _state.copyWith(
          lines: const [],
          clearCoupon: true,
          checkoutStatus: CheckoutStatus.success,
          orderId: orderId,
          clearCheckoutError: true,
        );
        _history.add(
          _state.copyWith(
            checkoutStatus: CheckoutStatus.idle,
            clearCheckoutError: true,
          ),
        );
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Order placed: $orderId')),
      );
    } on CheckoutException catch (e) {
      if (!mounted) return;

      setState(() {
        _state = _state.copyWith(
          checkoutStatus: CheckoutStatus.failure,
          checkoutError: e.message,
        );
      });
    }
  }

  void _clearCheckoutError() {
    setState(() {
      _state = _state.copyWith(
        checkoutStatus: CheckoutStatus.idle,
        clearCheckoutError: true,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cart · setState'),
        actions: [
          IconButton(
            tooltip: 'Undo',
            onPressed: _history.isEmpty ? null : _undo,
            icon: const Icon(Icons.undo),
          ),
        ],
      ),
      body: CartBody(
        state: _state,
        onAdd: _add,
        onQtyChanged: _changeQty,
        onApplyCoupon: _applyCoupon,
        onCheckout: _checkout,
        onClearCheckoutError: _clearCheckoutError,
      ),
    );
  }
}
