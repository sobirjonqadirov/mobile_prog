class Product {
  const Product({required this.id, required this.name, required this.price});
  final String id;
  final String name;
  final double price;
}

const catalog = [
  Product(id: 'p1', name: 'Keyboard', price: 49),
  Product(id: 'p2', name: 'Mouse', price: 25),
  Product(id: 'p3', name: 'Monitor', price: 199),
];

class CartLine {
  const CartLine({required this.product, required this.qty});
  final Product product;
  final int qty;
  double get subtotal => product.price * qty;
  CartLine copyWith({int? qty}) => CartLine(product: product, qty: qty ?? this.qty);
}

/// Pure, style-independent cart logic. Every state holder calls these.
extension CartLines on List<CartLine> {
  List<CartLine> withProduct(Product p) {
    final i = indexWhere((l) => l.product.id == p.id);

    if (i == -1) {
      return [...this, CartLine(product: p, qty: 1)];
    }

    return [
      for (final l in this)
        l.product.id == p.id
            ? l.copyWith(qty: l.qty + 1)
            : l,
    ];
  }

  List<CartLine> without(String productId) =>
      [for (final l in this) if (l.product.id != productId) l];

  List<CartLine> changeQty(String id, int delta) {
    return [
      for (final l in this)
        if (l.product.id != id)
          l
        else if (l.qty + delta > 0)
          l.copyWith(qty: l.qty + delta),
    ];
  }

  double get subtotal => fold(0, (s, l) => s + l.subtotal);

  int get itemCount => fold(0, (s, l) => s + l.qty);
}

enum CheckoutStatus {
  idle,
  submitting,
  success,
  failure,
}

class CartState {
  const CartState({
    this.lines = const [],
    this.coupon,
    this.couponError,
    this.checkoutStatus = CheckoutStatus.idle,
    this.orderId,
    this.checkoutError,
  });

  final List<CartLine> lines;
  final String? coupon;
  final String? couponError;

  final CheckoutStatus checkoutStatus;
  final String? orderId;
  final String? checkoutError;

  CartState copyWith({
    List<CartLine>? lines,
    String? coupon,
    String? couponError,
    CheckoutStatus? checkoutStatus,
    String? orderId,
    String? checkoutError,
    bool clearCoupon = false,
    bool clearCouponError = false,
    bool clearOrderId = false,
    bool clearCheckoutError = false,
  }) {
    return CartState(
      lines: lines ?? this.lines,
      coupon: clearCoupon ? null : coupon ?? this.coupon,
      couponError: clearCouponError ? null : couponError ?? this.couponError,
      checkoutStatus: checkoutStatus ?? this.checkoutStatus,
      orderId: clearOrderId ? null : orderId ?? this.orderId,
      checkoutError: clearCheckoutError
          ? null
          : checkoutError ?? this.checkoutError,
    );
  }

  int get itemCount => lines.itemCount;

  double get subtotal => lines.subtotal;

  double get discount => coupon == 'SAVE10' ? subtotal * 0.10 : 0;

  double get total => subtotal - discount;
}