import 'package:flutter/cupertino.dart';

class ProductProvider with ChangeNotifier {
  Map<String, dynamic> productData = {};
  getFormData(
      {String? productName,
      double? productPrice,
      int? quantity,
      String? category,
      String? description,
      DateTime? schedulDate,
      List<String>? imageUrlList,
      bool? chargeShippping,
      int? shippingCart,
      String? brandName,
      List<String>? sizeList}) {
    if (productName != null) {
      productData['prodcutName'] = productName;
    }

    if (productPrice != null) {
      productData['productPrice'] = productPrice;
    }
    if (quantity != null) {
      productData['quantity'] = quantity;
    }

    if (category != null) {
      productData['category'] = category;
    }

    if (description != null) {
      productData['description'] = description;
    }

    if (schedulDate != null) {
      productData['scheduleDate'] = schedulDate;
    }

    if (imageUrlList != null) {
      productData['imageUrlList'] = imageUrlList;
    }
    if (chargeShippping != null) {
      productData['chargeShippping'] = chargeShippping;
    }

    if (shippingCart != null) {
      productData['shippingCart'] = shippingCart;
    }
    if (brandName != null) {
      productData['brand'] = brandName;
    }
    if (sizeList != null) {
      productData['sizeList'] = sizeList;
    }
    notifyListeners();
  }

  clearData() {
    productData.clear();
    notifyListeners();
  }
}
