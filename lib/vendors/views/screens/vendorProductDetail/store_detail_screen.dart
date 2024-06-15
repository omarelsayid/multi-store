import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:multi_store/views/buyers/productDetail/product_detail_screen.dart';

class StoreDetailScreen extends StatelessWidget {
  const StoreDetailScreen({super.key, required this.storeData});
  final dynamic storeData;
  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> _productsStream = FirebaseFirestore.instance
        .collection('products')
        .where('vendorId', isEqualTo: storeData['vendorId'])
        .snapshots();
    return Scaffold(
      appBar: AppBar(
        title: Text(storeData['bussinessName']),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _productsStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text('Something went wrong'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(
                color: Colors.yellow[900],
              ),
            );
          }
          if (snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text(
                'No Product Uploaded',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            );
          }
          return GridView.builder(
            itemCount: snapshot.data!.docs.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
                childAspectRatio: 200 / 300),
            itemBuilder: (context, index) {
              final productData = snapshot.data!.docs[index];

              return GestureDetector(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(
                    builder: (context) {
                      return ProductDetailScreen(
                        productData: productData,
                      );
                    },
                  ));
                },
                child: Card(
                  child: Column(
                    children: [
                      Container(
                        height: 170,
                        width: 200,
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                image: NetworkImage(productData['imageUrl'][0]),
                                fit: BoxFit.cover)),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          productData['productName'],
                          style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 4),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          // ignore: prefer_interpolation_to_compose_strings
                          '\$' + productData['productPrice'].toStringAsFixed(2),
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 4,
                            color: Colors.yellow.shade900,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
