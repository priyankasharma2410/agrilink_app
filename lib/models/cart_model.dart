import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Cart Model
class CartModel extends ChangeNotifier {
  List<Map<String, dynamic>> _cartItems = [];

  List<Map<String, dynamic>> get cartItems => _cartItems;

  double get totalPrice => _cartItems.fold(0, (total, item) {
        // Extract numeric value from price, handle strings like "₹50/kg"
        final price = item['price'] is num
            ? item['price']
            : double.tryParse(item['price'].toString().replaceAll(RegExp(r'[^0-9.]'), '')) ?? 0;
        return total + price;
      });

  void addItem(Map<String, dynamic> product) {
    _cartItems.add(product);
    notifyListeners();
  }

  void removeItem(Map<String, dynamic> product) {
    _cartItems.remove(product);
    notifyListeners();
  }

  void clearCart() {
    _cartItems.clear();
    notifyListeners();
  }
}
