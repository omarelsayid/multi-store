// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CartAttr with ChangeNotifier {
  final String productName;
  final String productId;
  final List imageUrl;
  int quantity;
  int productQuantity;
  final double price;
  final String vendorId;
  final String productSize;
  final Timestamp sheduleDate;
  CartAttr(
      {required this.productQuantity,
      required this.productName,
      required this.productId,
      required this.imageUrl,
      required this.quantity,
      required this.price,
      required this.vendorId,
      required this.productSize,
      required this.sheduleDate});

  void increase() {
    quantity++;
  }

  void decrease() {
    quantity--;
  }
}
