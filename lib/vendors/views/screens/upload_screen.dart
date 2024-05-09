import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
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

  final GlobalKey<FormState> _formKey = GlobalKey();

  @override
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

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
            bottom: const TabBar(tabs: [
              Tab(
                child: Text(
                  'General',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              Tab(
                child: Text('Shipping', style: TextStyle(color: Colors.white)),
              ),
              Tab(
                child:
                    Text('Attributes', style: TextStyle(color: Colors.white)),
              ),
              Tab(
                child: Text('Images', style: TextStyle(color: Colors.white)),
              ),
            ]),
          ),
          body: const TabBarView(children: [
            GeneralTabScreen(),
            ShippingTabScreen(),
            AttributesTabScreen(),
            ImagesTabScreen(),
          ]),
          bottomSheet: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5)),
                  backgroundColor: Colors.yellow[900],
                  foregroundColor: Colors.white,
                ),
                onPressed: () async {
                  EasyLoading.show();
                  final productId = const Uuid().v4();
                  await _firestore.collection('products').doc(productId).set({
                    'quantity': _productProvider.productData['quantity'],
                    'productPrice':
                        _productProvider.productData['productPrice'],
                    'productName': _productProvider.productData['prodcutName'],
                    'productId': productId,
                    'imageUrl': _productProvider.productData['imageUrlList'],
                    'description': _productProvider.productData['description'],
                    'category': _productProvider.productData['category'],
                    'scheduleDate':
                        _productProvider.productData['scheduleDate'],
                    'chargeShippping':
                        _productProvider.productData['chargeShippping'],
                    'sizeList': _productProvider.productData['sizeList'],
                    'brand': _productProvider.productData['brand'],
                    'shippingCart':
                        _productProvider.productData['shippingCart'],
                  }).whenComplete(() {
                    log(_productProvider.productData.toString());
                    EasyLoading.dismiss();
                    _productProvider.clearData();
                    Navigator.push(context, MaterialPageRoute(
                      builder: (context) {
                        return const MainVendorScreen();
                      },
                    ));
                  });
                },
                child: const Text(
                  'Save',
                  style: TextStyle(color: Colors.white),
                )),
          ),
        ),
      ),
    );
  }
}
