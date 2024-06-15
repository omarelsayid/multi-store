import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:multi_store/utils/show_snak_bar.dart';

class VendorProductDetailScreen extends StatefulWidget {
  final dynamic productData;
  const VendorProductDetailScreen({super.key, required this.productData});

  @override
  State<VendorProductDetailScreen> createState() =>
      _VendorProductDetailScreenState();
}

class _VendorProductDetailScreenState extends State<VendorProductDetailScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController _productNameController = TextEditingController();
  final TextEditingController _brandNameController = TextEditingController();
  final TextEditingController _qunatityController = TextEditingController();
  final TextEditingController _productPriceController = TextEditingController();
  final TextEditingController _productDescriptionController =
      TextEditingController();
  final TextEditingController _productCategoryController =
      TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      _productNameController.text = widget.productData['productName'];
      _brandNameController.text = widget.productData['brand'];
      _qunatityController.text = widget.productData['quantity'].toString();
      _productPriceController.text =
          widget.productData['productPrice'].toString();
      _productDescriptionController.text = widget.productData['description'];
      _productCategoryController.text = widget.productData['category'];
    });
  }

  double? productPrice;
  int? productQuantity;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      appBar: AppBar(
        backgroundColor: Colors.yellow[900],
        title: Text(widget.productData['productName']),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextFormField(
              controller: _productNameController,
              decoration: const InputDecoration(labelText: 'Product Name'),
            ),
            const SizedBox(
              height: 20,
            ),
            TextFormField(
              controller: _brandNameController,
              decoration: const InputDecoration(labelText: 'Brand Name'),
            ),
            const SizedBox(
              height: 20,
            ),
            TextFormField(
              onChanged: (value) {
                productQuantity = int.parse(value);
              },
              controller: _qunatityController,
              decoration: const InputDecoration(labelText: 'quantity '),
            ),
            const SizedBox(
              height: 20,
            ),
            TextFormField(
              onChanged: (value) {
                productPrice = double.parse(value);
              },
              controller: _productPriceController,
              decoration: const InputDecoration(labelText: 'product Price'),
            ),
            const SizedBox(
              height: 20,
            ),
            TextFormField(
              maxLength: 800,
              maxLines: 3,
              controller: _productDescriptionController,
              decoration:
                  const InputDecoration(labelText: 'product description'),
            ),
            TextFormField(
              enabled: true,
              controller: _productCategoryController,
              decoration: const InputDecoration(labelText: 'product category'),
            ),
          ],
        ),
      ),
      bottomSheet: InkWell(
        onTap: () async {
          if (productPrice != null && productQuantity != null) {
            await _firestore
                .collection('products')
                .doc(widget.productData['productId'])
                .update({
              'productName': _productNameController.text,
              'brand': _brandNameController.text,
              'quantity': productQuantity,
              'productPrice': productPrice,
              'description': _productDescriptionController.text,
              'category': _productCategoryController.text,
            });
          } else {
            showSnakBar(context, 'Update quantity And Price');
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Container(
            height: 40,
            width: MediaQuery.sizeOf(context).width,
            decoration: BoxDecoration(
              color: Colors.yellow[900],
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Center(
              child: Text(
                'UPDATE PRODUCT',
                style: TextStyle(
                    fontSize: 18,
                    letterSpacing: 6,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
