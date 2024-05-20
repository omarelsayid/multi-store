import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:multi_store/provider/cart_provider.dart';
import 'package:provider/provider.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  Widget build(BuildContext context) {
    final CartProvider _cartProvider = Provider.of<CartProvider>(context);
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {
                _cartProvider.removeAllItems();
              },
              icon: const Icon(CupertinoIcons.delete))
        ],
        backgroundColor: Colors.yellow[900],
        elevation: 0,
        title: const Text(
          'Cart Screen',
          style: TextStyle(
              fontWeight: FontWeight.bold,
              letterSpacing: 4,
              debugLabel: 'omar'),
        ),
      ),
      body: ListView.builder(
        shrinkWrap: true,
        itemCount: _cartProvider.getCartItem.length,
        itemBuilder: (context, index) {
          final cartData = _cartProvider.getCartItem.values.toList()[index];
          return Card(
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
                          '\$' + " " + cartData.price.toStringAsFixed(2),
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
                        Row(
                          children: [
                            Container(
                              height: 40,
                              width: 120,
                              decoration: BoxDecoration(
                                color: Colors.yellow[900],
                              ),
                              child: Row(
                                children: [
                                  IconButton(
                                      onPressed: cartData.quantity == 1
                                          ? null
                                          : () {
                                              setState(() {
                                                _cartProvider
                                                    .dereament(cartData);
                                              });
                                            },
                                      icon: const Icon(
                                        CupertinoIcons.minus,
                                        color: Colors.white,
                                      )),
                                  Text(
                                    cartData.quantity.toString(),
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                  IconButton(
                                      onPressed: cartData.productQuantity ==
                                              cartData.quantity
                                          ? null
                                          : () {
                                              setState(() {
                                                _cartProvider
                                                    .increament(cartData);
                                              });
                                            },
                                      icon: const Icon(
                                        CupertinoIcons.plus,
                                        color: Colors.white,
                                      ))
                                ],
                              ),
                            ),
                            IconButton(
                                onPressed: () {
                                  _cartProvider.removeItem(cartData.productId);
                                },
                                icon:
                                    const Icon(CupertinoIcons.cart_badge_minus))
                          ],
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          );
        },
      ),

      //     body: Center(
      //   child: Column(
      //     mainAxisAlignment: MainAxisAlignment.center,
      //     children: [
      //       const Text(
      //         'Your Shopping Cart is Empty',
      //         style: TextStyle(
      //             fontSize: 22, fontWeight: FontWeight.bold, letterSpacing: 5),
      //       ),
      //       const SizedBox(
      //         height: 20,
      //       ),
      //       Container(
      //         height: 40,
      //         width: MediaQuery.of(context).size.width,
      //         decoration: BoxDecoration(
      //           color: Colors.yellow.shade900,
      //           borderRadius: BorderRadius.circular(10),
      //         ),
      //         child: const Center(
      //           child: Text(
      //             'CONTINUE SHOPPING',
      //             style: TextStyle(
      //               fontSize: 19,
      //               color: Colors.white,
      //             ),
      //           ),
      //         ),
      //       )
      //     ],
      //   ),
      // )

      bottomSheet: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          height: 50,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.yellow.shade900,
          ),
          child: Center(
            child: Text(
              '\$' +
                  _cartProvider.totalPrice.toStringAsFixed(2) +
                  ' ' +
                  'CHECKOUT',
              style: const TextStyle(
                  color: Colors.white,
                  letterSpacing: 8,
                  fontSize: 18,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }
}
