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
    this.showSummary = true,
    this.showCheckoutErrorBanner = true,
  });

  final CartState state;

  final void Function(Product) onAdd;
  final void Function(String productId, int delta) onQtyChanged;
  final void Function(String code) onApplyCoupon;
  final VoidCallback onCheckout;
  final VoidCallback onClearCheckoutError;

  final bool showSummary;
  final bool showCheckoutErrorBanner;

  @override
  State<CartBody> createState() => _CartBodyState();
}

class _CartBodyState extends State<CartBody> {
  final TextEditingController _couponController =
      TextEditingController();

  @override
  void dispose() {
    _couponController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = widget.state;
    final isSubmitting =
        state.checkoutStatus == CheckoutStatus.submitting;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Checkout error banner
          if (widget.showCheckoutErrorBanner &&
              state.checkoutStatus == CheckoutStatus.failure)
            MaterialBanner(
              content: Text(
                state.checkoutError ?? 'Checkout failed',
              ),
              actions: [
                TextButton(
                  onPressed: widget.onClearCheckoutError,
                  child: const Text('Dismiss'),
                ),
              ],
            ),

          const SizedBox(height: 16),

          // Product catalog
          const Text(
            'Products',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 8),

          for (final product in catalog)
            Card(
              child: ListTile(
                title: Text(product.name),
                subtitle: Text(
                  '\$${product.price.toStringAsFixed(2)}',
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.add_shopping_cart),
                  onPressed: () => widget.onAdd(product),
                ),
              ),
            ),

          const SizedBox(height: 24),

          // Cart contents
          const Text(
            'Your Cart',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),

          if (state.lines.isEmpty)
            const Padding(
              padding: EdgeInsets.all(24),
              child: Center(
                child: Text('Cart is empty'),
              ),
            )
          else
            Column(
              children: [
                for (final line in state.lines)
                  ListTile(
                    key: ValueKey(line.product.id),
                    title: Text(line.product.name),
                    subtitle: Text(
                      '\$${line.product.price.toStringAsFixed(2)}'
                      ' × ${line.qty}',
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.remove),
                          onPressed: () => widget.onQtyChanged(
                            line.product.id,
                            -1,
                          ),
                        ),
                        Text('${line.qty}'),
                        IconButton(
                          icon: const Icon(Icons.add),
                          onPressed: () => widget.onQtyChanged(
                            line.product.id,
                            1,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),

          const SizedBox(height: 24),

          // Coupon input
          const Text(
            'Coupon',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 8),

          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _couponController,
                  decoration: const InputDecoration(
                    labelText: 'Enter coupon code',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              FilledButton(
                onPressed: () {
                  widget.onApplyCoupon(_couponController.text);
                },
                child: const Text('Apply'),
              ),
            ],
          ),

          if (state.couponError != null)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                state.couponError!,
                style: const TextStyle(color: Colors.red),
              ),
            ),

          const SizedBox(height: 16),

          // Summary card
          if (widget.showSummary)
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _summaryRow(
                      'Items',
                      '${state.itemCount}',
                    ),
                    _summaryRow(
                      'Subtotal',
                      '\$${state.subtotal.toStringAsFixed(2)}',
                    ),
                    _summaryRow(
                      'Discount',
                      '-\$${state.discount.toStringAsFixed(2)}',
                    ),
                    const Divider(),
                    _summaryRow(
                      'Total',
                      '\$${state.total.toStringAsFixed(2)}',
                      bold: true,
                    ),
                  ],
                ),
              ),
            ),

          const SizedBox(height: 16),

          // Checkout button
          FilledButton(
            onPressed: isSubmitting || state.lines.isEmpty
                ? null
                : widget.onCheckout,
            child: isSubmitting
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                    ),
                  )
                : const Text('Checkout'),
          ),
        ],
      ),
    );
  }

  Widget _summaryRow(
    String label,
    String value, {
    bool bold = false,
  }) {
    final style = TextStyle(
      fontWeight: bold ? FontWeight.bold : FontWeight.normal,
    );

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: style),
          Text(value, style: style),
        ],
      ),
    );
  }
}