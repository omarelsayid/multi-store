import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:multi_store/provider/cart_provider.dart';
import 'package:multi_store/vendors/views/screens/edit_screen.dart';
import 'package:multi_store/views/buyers/inner_screens/edit_profile_screen.dart';
import 'package:multi_store/views/buyers/main_screen.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class CheckOutScreen extends StatefulWidget {
  const CheckOutScreen({super.key});

  @override
  State<CheckOutScreen> createState() => _CheckOutScreenState();
}

class _CheckOutScreenState extends State<CheckOutScreen> {
  @override
  Widget build(BuildContext context) {
    final CartProvider _cartprovider = Provider.of<CartProvider>(context);
    CollectionReference buyers =
        FirebaseFirestore.instance.collection('buyers');
    FirebaseFirestore _firestore = FirebaseFirestore.instance;
    return FutureBuilder<DocumentSnapshot>(
      future: buyers.doc(FirebaseAuth.instance.currentUser!.uid).get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Center(child: Text("Something went wrong"));
        }

        if (snapshot.hasData && !snapshot.data!.exists) {
          log(FirebaseAuth.instance.currentUser!.displayName.toString());
          return const Center(child: Text("Document does not exist"));
        }

        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data =
              snapshot.data!.data() as Map<String, dynamic>;
          return Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.yellow.shade900,
              title: const Text(
                'Checkout',
                style: TextStyle(
                    fontSize: 18,
                    letterSpacing: 6,
                    fontWeight: FontWeight.bold),
              ),
            ),
            body: ListView.builder(
              shrinkWrap: true,
              itemCount: _cartprovider.getCartItem.length,
              itemBuilder: (context, index) {
                final cartData =
                    _cartprovider.getCartItem.values.toList()[index];
                return Padding(
                  padding: const EdgeInsets.all(10),
                  child: Card(
                    child: SizedBox(
                      height: 170,
                      child: Row(
                        children: [
                          SizedBox(
                            height: 100,
                            width: 100,
                            child: Image.network(cartData.imageUrl[0]),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  cartData.productName,
                                  style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 5),
                                ),
                                Text(
                                  '\$' +
                                      " " +
                                      cartData.price.toStringAsFixed(2),
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 5,
                                      color: Colors.yellow[900]),
                                ),
                                OutlinedButton(
                                  onPressed: null,
                                  child: Text(
                                    cartData.productSize,
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
            bottomNavigationBar: data['adderss'] == ''
                ? TextButton(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(
                        builder: (context) {
                          return EditProfileScreen(
                            userData: data,
                          );
                        },
                      )).whenComplete(() {
                        Navigator.pop(context);
                      });
                    },
                    child: const Text('Enter the Billing address'))
                : Padding(
                    padding: const EdgeInsets.all(13),
                    child: InkWell(
                      onTap: () {
                        EasyLoading.show(status: 'PLacing order');
                        _cartprovider.getCartItem.forEach((key, item) async {
                          final String orderID = Uuid().v4();
                          await _firestore
                              .collection('orders')
                              .doc(orderID)
                              .set({
                            'orderId': orderID,
                            'vendorId': item.vendorId,
                            'email': data['email'],
                            'phone': data['phoneNumber'],
                            'address': data['address'],
                            'buyerId': data['buyerId'],
                            'fullName': data['fullName'],
                            'userPhoto': data['profileImage'],
                            'productName': item.productName,
                            'productPrice': item.price,
                            'productId': item.productId,
                            'productImage': item.imageUrl,
                            'quantity': item.productQuantity,
                            'sheduleDate': item.sheduleDate,
                            'orderDate': DateTime.now(),
                            'accepted': false,
                          }).whenComplete(() {
                            setState(() {
                              _cartprovider.getCartItem.clear();
                              EasyLoading.dismiss();
                              Navigator.pushReplacement(context,
                                  MaterialPageRoute(
                                builder: (context) {
                                  return const MainScreen();
                                },
                              ));
                            });
                          });
                        });
                      },
                      child: Container(
                        height: 50,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          color: Colors.yellow[900],
                        ),
                        child: const Center(
                          child: Text(
                            'PLACE ORDER',
                            style: TextStyle(
                              color: Colors.white,
                              letterSpacing: 6,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
          );
        }

        return Center(
          child: CircularProgressIndicator(
            color: Colors.yellow[900],
          ),
        );
      },
    );
  }
}
