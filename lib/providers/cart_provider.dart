import 'package:flutter/material.dart';
import '../models/product.dart';

class CartItem {
  final Product product;
  int quantity;

  CartItem({
    required this.product,
    required this.quantity,
  });

  Map<String, dynamic> toMap() {
    return {
      'product': product.toMap(),
      'quantity': quantity,
    };
  }

  factory CartItem.fromMap(Map<String, dynamic> map) {
    return CartItem(
      product: Product.fromMap(map['product']),
      quantity: map['quantity'] ?? 1,
    );
  }

  double get totalPrice => product.price * quantity;
}

class CartProvider with ChangeNotifier {
  List<CartItem> _items = [];

  List<CartItem> get items => _items;
  int get itemCount => _items.fold(0, (sum, item) => sum + item.quantity);
  double get totalAmount => _items.fold(0.0, (sum, item) => sum + item.totalPrice);

  void addItem(Product product, {int quantity = 1}) {
    int existingIndex = _items.indexWhere((item) => item.product.id == product.id);
    
    if (existingIndex != -1) {
      _items[existingIndex].quantity += quantity;
    } else {
      _items.add(CartItem(product: product, quantity: quantity));
    }
    
    notifyListeners();
  }

  void removeItem(String productId) {
    _items.removeWhere((item) => item.product.id == productId);
    notifyListeners();
  }

  void updateQuantity(String productId, int quantity) {
    if (quantity <= 0) {
      removeItem(productId);
      return;
    }

    int index = _items.indexWhere((item) => item.product.id == productId);
    if (index != -1) {
      _items[index].quantity = quantity;
      notifyListeners();
    }
  }

  void incrementQuantity(String productId) {
    int index = _items.indexWhere((item) => item.product.id == productId);
    if (index != -1) {
      _items[index].quantity++;
      notifyListeners();
    }
  }

  void decrementQuantity(String productId) {
    int index = _items.indexWhere((item) => item.product.id == productId);
    if (index != -1) {
      if (_items[index].quantity > 1) {
        _items[index].quantity--;
      } else {
        removeItem(productId);
      }
      notifyListeners();
    }
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
  }

  bool isInCart(String productId) {
    return _items.any((item) => item.product.id == productId);
  }

  CartItem? getCartItem(String productId) {
    try {
      return _items.firstWhere((item) => item.product.id == productId);
    } catch (e) {
      return null;
    }
  }

  int getQuantity(String productId) {
    CartItem? item = getCartItem(productId);
    return item?.quantity ?? 0;
  }

  Map<String, dynamic> toMap() {
    return {
      'items': _items.map((item) => item.toMap()).toList(),
    };
  }

  void fromMap(Map<String, dynamic> map) {
    _items = (map['items'] as List<dynamic>?)
        ?.map((item) => CartItem.fromMap(item))
        .toList() ?? [];
    notifyListeners();
  }
}
