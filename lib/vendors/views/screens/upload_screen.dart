import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:multi_store/provider/product_provider.dart';
import 'package:multi_store/vendors/views/screens/main_vendor_screen.dart';
import 'package:multi_store/vendors/views/screens/upload_tab_screens/attributes-tab_screen.dart';
import 'package:multi_store/vendors/views/screens/upload_tab_screens/general_tab_screen.dart';
import 'package:multi_store/vendors/views/screens/upload_tab_screens/images_tab_screen.dart';
import 'package:multi_store/vendors/views/screens/upload_tab_screens/shipping_tab_screen.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class UploadScreen extends StatelessWidget {
  UploadScreen({super.key});

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    final ProductProvider _productProvider =
        Provider.of<ProductProvider>(context);
    return DefaultTabController(
      length: 4,
      child: Form(
        key: _formKey,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.yellow.shade900,
            bottom: const TabBar(
              tabs: [
                Tab(
                    child:
                        Text('General', style: TextStyle(color: Colors.white))),
                Tab(
                    child: Text('Shipping',
                        style: TextStyle(color: Colors.white))),
                Tab(
                    child: Text('Attributes',
                        style: TextStyle(color: Colors.white))),
                Tab(
                    child:
                        Text('Images', style: TextStyle(color: Colors.white))),
              ],
            ),
          ),
          body: const TabBarView(
            children: [
              // Replace these with your actual forms for each tab
              GeneralTabScreen(),
              ShippingTabScreen(),
              AttributesTabScreen(),
              ImagesTabScreen(),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () async {
              if (_formKey.currentState!.validate()) {
                EasyLoading.show();
                final productId = const Uuid().v4();
                await _firestore.collection('products').doc(productId).set({
                  'quantity': _productProvider.productData['quantity'],
                  'productPrice': _productProvider.productData['productPrice'],
                  'productName': _productProvider.productData['prodcutName'],
                  'productId': productId,
                  'imageUrl': _productProvider.productData['imageUrlList'],
                  'description': _productProvider.productData['description'],
                  'category': _productProvider.productData['category'],
                  'scheduleDate': _productProvider.productData['scheduleDate'],
                  'chargeShippping':
                      _productProvider.productData['chargeShippping'],
                  'sizeList': _productProvider.productData['sizeList'],
                  'brand': _productProvider.productData['brand'],
                  'shippingCart': _productProvider.productData['shippingCart'],
                  'vendorId': FirebaseAuth.instance.currentUser!.uid,
                  'approved': false,
                }).whenComplete(() {
                  log(_productProvider.productData.toString());
                  EasyLoading.dismiss();
                  _productProvider.clearData();
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const MainVendorScreen(),
                      ));
                });
              }
            },
            backgroundColor: Colors.yellow[900],
            child: const Icon(Icons.save),
          ),
        ),
      ),
    );
  }
}
