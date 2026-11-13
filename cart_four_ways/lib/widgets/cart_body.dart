import 'package:flutter/material.dart';
import '../models/cart.dart';

class CartBody extends StatefulWidget {
  const CartBody({
    super.key,
    required this.state,
    required this.onAdd,
    required this.onQtyChanged,
    required this.onApplyCoupon,
    required this.onCheckout,
    required this.onClearCheckoutError,
  });

  final CartState state;
  final void Function(Product) onAdd;
  final void Function(String productId, int delta) onQtyChanged;
  final void Function(String code) onApplyCoupon;
  final VoidCallback onCheckout;
  final VoidCallback onClearCheckoutError;

  @override
  State<CartBody> createState() => _CartBodyState();
}

class _CartBodyState extends State<CartBody> {
  final TextEditingController _couponController = TextEditingController();

  @override
  void dispose() {
    _couponController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = widget.state;

    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Wrap(
              spacing: 8,
              children: [
                for (final p in catalog)
                  ActionChip(
                    label: Text(
                      '${p.name} · ${p.price.toStringAsFixed(0)}',
                    ),
                    onPressed: () => widget.onAdd(p),
                  ),
                if (state.checkoutStatus == CheckoutStatus.failure)
                  MaterialBanner(
                    content: Text(state.checkoutError ?? 'Checkout failed'),
                    backgroundColor: Colors.red.shade50,
                    actions: [
                      TextButton(
                        onPressed: widget.onClearCheckoutError,
                        child: const Text('Dismiss'),
                      ),
                    ],
                  ),
              ],
            ),
          ),
          state.lines.isEmpty
            ? const Padding(
                padding: EdgeInsets.all(24),
                child: Center(child: Text('Cart is empty')),
              )
            : Column(
                children: [
                  for (final l in state.lines)
                    ListTile(
                      key: ValueKey(l.product.id),
                      title: Text(l.product.name),
                      subtitle: Text('× ${l.qty}'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.remove),
                            onPressed: () => widget.onQtyChanged(
                              l.product.id,
                              -1,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.add),
                            onPressed: () => widget.onQtyChanged(
                              l.product.id,
                              1,
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                TextField(
                  controller: _couponController,
                  decoration: const InputDecoration(
                    labelText: 'Coupon code',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: () {
                      widget.onApplyCoupon(_couponController.text);
                    },
                    child: const Text('Apply'),
                  ),
                ),
                if (state.couponError != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      state.couponError!,
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),
                if (state.coupon != null)
                  Text('Applied coupon: ${state.coupon}'),
              ],
            ),
          ),
          Card(
            margin: const EdgeInsets.all(12),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  const Text(
                    'Cart Summary',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ListTile(
                    title: const Text('Item count'),
                    trailing: Text('${state.itemCount}'),
                  ),
                  ListTile(
                    title: const Text('Subtotal'),
                    trailing: Text(state.subtotal.toStringAsFixed(2)),
                  ),
                  ListTile(
                    title: const Text('Discount'),
                    trailing: Text('-${state.discount.toStringAsFixed(2)}'),
                  ),
                  const Divider(),
                  ListTile(
                    title: const Text(
                      'Total',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    trailing: Text(
                      state.total.toStringAsFixed(2),
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed:
                    state.checkoutStatus == CheckoutStatus.submitting ||
                            state.lines.isEmpty
                        ? null
                        : widget.onCheckout,
                child: state.checkoutStatus == CheckoutStatus.submitting
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                        ),
                      )
                    : const Text('Checkout'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}