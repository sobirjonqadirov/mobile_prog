import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/cart.dart';
import '../widgets/cart_body.dart';
import 'cart_notifier.dart';

class RiverpodCartPage extends ConsumerWidget {
  const RiverpodCartPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(cartProvider);
    final cart = ref.read(cartProvider.notifier);
    final canUndo = ref.watch(canUndoProvider);

    ref.listen(
      cartProvider.select((s) => s.checkoutStatus),
      (previous, next) {
        final messenger = ScaffoldMessenger.of(context);

        if (next == CheckoutStatus.success) {
          messenger.showSnackBar(
            SnackBar(
              content: Text('Order placed: ${ref.read(cartProvider).orderId}'),
            ),
          );
        }

        if (next == CheckoutStatus.failure) {
          messenger.showMaterialBanner(
            MaterialBanner(
              content: Text(
                ref.read(cartProvider).checkoutError ?? 'Checkout failed',
              ),
              actions: [
                TextButton(
                  onPressed: messenger.hideCurrentMaterialBanner,
                  child: const Text('Dismiss'),
                ),
              ],
            ),
          );
        }
      },
    );

    ref.listen(cartProvider, (previous, next) {
      debugPrint('Cart state changed: $previous -> $next');
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cart · Riverpod'),
        actions: [
          IconButton(
            tooltip: 'Undo',
            onPressed: canUndo ? cart.undo : null,
            icon: const Icon(Icons.undo),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: CartBody(
              state: state,
              onAdd: cart.add,
              onQtyChanged: cart.changeQty,
              onApplyCoupon: cart.applyCoupon,
              onCheckout: cart.checkout,
              onClearCheckoutError: cart.clearCheckoutError,
              showSummary: false,
              showCheckoutErrorBanner: false,
            ),
          ),
          const RiverpodCartSummary(),
        ],
      ),
    );
  }
}

class RiverpodCartSummary extends ConsumerWidget {
  const RiverpodCartSummary({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final total = ref.watch(
      cartProvider.select((state) => state.total),
    );

    debugPrint('RiverpodCartSummary rebuilt. Total: $total');

    return Card(
      margin: const EdgeInsets.all(12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Total',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(
              total.toStringAsFixed(2),
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}