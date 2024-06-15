import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:multi_store/views/buyers/models/cart_attributes.dart';

class CartProvider with ChangeNotifier {
  Map<String, CartAttr> _cartItems = {};
  Map<String, CartAttr> get getCartItem {
    return _cartItems;
  }

  double get totalPrice {
    var total = 0.0;
    _cartItems.forEach((key, value) {
      total += value.price * value.quantity;
    });
    return total;
  }

  void addProductToCart(
      String productName,
      String productId,
      List imageUrl,
      int productQuantity,
      int quantity,
      double price,
      String vendorId,
      String productSize,
      Timestamp sheduleDate) {
    if (_cartItems.containsKey(productId)) {
      _cartItems.update(
          productId,
          (exitingCart) => CartAttr(
              productQuantity: exitingCart.productQuantity,
              productName: exitingCart.productName,
              productId: exitingCart.productId,
              imageUrl: exitingCart.imageUrl,
              quantity: exitingCart.quantity + 1,
              price: exitingCart.price,
              vendorId: exitingCart.vendorId,
              productSize: exitingCart.productSize,
              sheduleDate: exitingCart.sheduleDate));

      notifyListeners();
    } else {
      _cartItems.putIfAbsent(
          productId,
          () => CartAttr(
              productQuantity: productQuantity,
              productName: productName,
              productId: productId,
              imageUrl: imageUrl,
              quantity: quantity,
              price: price,
              vendorId: vendorId,
              productSize: productSize,
              sheduleDate: sheduleDate));
      notifyListeners();
    }
  }

  void increament(CartAttr cartAttr) {
    cartAttr.increase();
    notifyListeners();
  }

  void dereament(CartAttr cartAttr) {
    cartAttr.decrease();
    notifyListeners();
  }

  void removeItem(productId) {
    _cartItems.remove(productId);
    notifyListeners();
  }

  void removeAllItems() {
    _cartItems.clear();
    notifyListeners();
  }
}
