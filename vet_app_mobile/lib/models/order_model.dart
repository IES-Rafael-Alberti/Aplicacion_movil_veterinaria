import 'cart_model.dart';

class OrderLineItem {
  final String name;
  final String imageUrl;
  final double price;
  final int quantity;

  const OrderLineItem({
    required this.name,
    required this.imageUrl,
    required this.price,
    required this.quantity,
  });

  factory OrderLineItem.fromCartItem(CartItem item) {
    return OrderLineItem(
      name: item.product.name,
      imageUrl: item.product.imageUrl,
      price: item.product.price,
      quantity: item.quantity,
    );
  }

  double get subtotal => price * quantity;
}

class OrderRecord {
  final String address;
  final String city;
  final String postal;
  final DateTime date;
  final List<OrderLineItem> items;

  const OrderRecord({
    required this.address,
    required this.city,
    required this.postal,
    required this.date,
    required this.items,
  });

  double get total => items.fold(0, (sum, item) => sum + item.subtotal);
}

class OrderHistory {
  static final List<OrderRecord> _orders = [];

  static List<OrderRecord> get orders => List.unmodifiable(_orders);

  static void add(OrderRecord order) {
    _orders.add(order);
  }
}