import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:multi_store/views/buyers/inner_screens/all_product.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  final Stream<QuerySnapshot> _productStream =
      FirebaseFirestore.instance.collection('categroies').snapshots();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        backgroundColor: Colors.white,
        title: const Text(
          'Categories',
          style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 3),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _productStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text('Something went wrong'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          return Container(
            height: 200,
            child: ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                final categoryData = snapshot.data!.docs[index];
                return Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: ListTile(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(
                        builder: (context) {
                          return AllProductScreen(
                            categoryData: categoryData,
                          );
                        },
                      ));
                    },
                    leading: Image.network(categoryData['image']),
                    title: Text(categoryData['categoryName']),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
