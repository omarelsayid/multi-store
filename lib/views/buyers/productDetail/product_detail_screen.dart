import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:multi_store/provider/cart_provider.dart';
import 'package:multi_store/utils/show_snak_bar.dart';
import 'package:photo_view/photo_view.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ProductDetailScreen extends StatefulWidget {
  const ProductDetailScreen({super.key, this.productData});
  final dynamic productData;

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  int _imageIdex = 0;
  String? _selectedSize;
  String formateDate(date) {
    final outPutDateFormate = DateFormat('dd/MM/yyyy');
    final outPutDate = outPutDateFormate.format(date);
    return outPutDate;
  }

  @override
  Widget build(BuildContext context) {
    final CartProvider _cartprovider = Provider.of<CartProvider>(context);
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        iconTheme: const IconThemeData(color: Colors.black),
        title: Text(
          widget.productData['productName'],
          strutStyle:
              const StrutStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                Container(
                  height: 300,
                  width: double.infinity,
                  child: PhotoView(
                    imageProvider: NetworkImage(
                      widget.productData['imageUrl'][_imageIdex],
                    ),
                  ),
                ),
                Positioned(
                    bottom: 0,
                    child: Container(
                      height: 50,
                      width: MediaQuery.of(context).size.width,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: widget.productData['imageUrl'].length,
                        itemBuilder: (context, index) {
                          return InkWell(
                            onTap: () {
                              setState(() {
                                _imageIdex = index;
                              });
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors.yellow.shade900)),
                                height: 60,
                                width: 60,
                                child: Image.network(
                                    widget.productData['imageUrl'][index]),
                              ),
                            ),
                          );
                        },
                      ),
                    ))
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.all(13.0),
              child: Text(
                '\$' + widget.productData['productPrice'].toStringAsFixed(2),
                style: TextStyle(
                    fontSize: 22,
                    letterSpacing: 8,
                    fontWeight: FontWeight.bold,
                    color: Colors.yellow[900]),
              ),
            ),
            Text(
              widget.productData['productName'],
              style: const TextStyle(
                  fontSize: 22, letterSpacing: 8, fontWeight: FontWeight.bold),
            ),
            ExpansionTile(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'product Description',
                    style: TextStyle(color: Colors.yellow.shade900),
                  ),
                  Text(
                    'View More ',
                    style: TextStyle(color: Colors.yellow.shade900),
                  )
                ],
              ),
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    widget.productData['description'],
                    style: const TextStyle(
                        fontSize: 17, color: Colors.grey, letterSpacing: 2),
                    textAlign: TextAlign.center,
                  ),
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  'This Product Will be Shipping On',
                  style: TextStyle(
                      color: Colors.yellow[900],
                      fontWeight: FontWeight.bold,
                      fontSize: 18),
                ),
                Text(
                  formateDate(widget.productData['scheduleDate'].toDate()),
                  style: const TextStyle(
                      color: Colors.blue,
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                )
              ],
            ),
            ExpansionTile(
              title: const Text('Avaliable Size'),
              children: [
                Container(
                  height: 50,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: widget.productData['sizeList'].length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          color: _selectedSize ==
                                  widget.productData['sizeList'][index]
                              ? Colors.yellow
                              : null,
                          child: OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              shape: const RoundedRectangleBorder(),
                            ),
                            onPressed: () {
                              setState(() {
                                _selectedSize =
                                    widget.productData['sizeList'][index];
                              });
                              log(_selectedSize!);
                            },
                            child: Text(
                              widget.productData['sizeList'][index],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                )
              ],
            )
          ],
        ),
      ),
      bottomSheet: InkWell(
        onTap: _cartprovider.getCartItem
                .containsKey(widget.productData['productId'])
            ? null
            : () {
                if (_selectedSize == null) {
                  return showSnakBar(context, 'Please Select A Size');
                } else {
                  _cartprovider.addProductToCart(
                      widget.productData['productName'],
                      widget.productData['productId'],
                      widget.productData['imageUrl'],
                      widget.productData['quantity'],
                      1,
                      widget.productData['productPrice'],
                      widget.productData['vendorId'],
                      _selectedSize!,
                      widget.productData['scheduleDate']);
                  return showSnakBar(context, 'You Added ${widget.productData['productName']} To Your Cart');
                }
              },
        child: Container(
          height: 50,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
              color: _cartprovider.getCartItem
                      .containsKey(widget.productData['productId'])
                  ? Colors.grey
                  : Colors.yellow[900],
              borderRadius: BorderRadius.circular(10)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Icon(
                  CupertinoIcons.cart,
                  color: Colors.white,
                ),
              ),
              _cartprovider.getCartItem
                      .containsKey(widget.productData['productId'])
                  ? const Text(
                      'IN CART',
                      style: TextStyle(
                          fontSize: 18,
                          letterSpacing: 5,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    )
                  : const Text(
                      'ADD TO CART',
                      style: TextStyle(
                          fontSize: 18,
                          letterSpacing: 5,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    )
            ],
          ),
        ),
      ),
    );
  }
}
