import 'mock_data.dart';

class CartItem {
  final Product product;
  int quantity;

  CartItem({required this.product, this.quantity = 1});
}

class CartModel {
  final List<CartItem> items = [];

  void addProduct(Product product) {
    final index = items.indexWhere((item) => item.product == product);
    if (index >= 0) {
      items[index].quantity++;
    } else {
      items.add(CartItem(product: product));
    }
  }

  void removeProduct(Product product) {
    items.removeWhere((item) => item.product == product);
  }

  void clear() {
    items.clear();
  }

  double get total => items.fold(0, (sum, item) => sum + item.product.price * item.quantity);
}
