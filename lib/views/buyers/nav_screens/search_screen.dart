import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:multi_store/views/buyers/productDetail/product_detail_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  String _searchedValue = '';

  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> _prodcutsStream =
        FirebaseFirestore.instance.collection('products').snapshots();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.yellow[800],
        elevation: 0,
        title: TextFormField(
          onFieldSubmitted: (value) {
            setState(() {
              _searchedValue = value;
            });
          },
          decoration: const InputDecoration(
              labelText: 'Search For Products',
              labelStyle: TextStyle(color: Colors.white, letterSpacing: 4),
              prefixIcon: Icon(Icons.search)),
        ),
      ),
      body: _searchedValue == ''
          ? const Center(
              child: Text(
                'Search For Prodcuts',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 5),
              ),
            )
          : StreamBuilder<QuerySnapshot>(
              stream: _prodcutsStream,
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return Text('Something went wrong');
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Text("Loading");
                }

                final searchedData = snapshot.data!.docs.where((element) {
                  return element['productName']
                      .toLowerCase()
                      .contains(_searchedValue.toLowerCase());
                });
                return Column(
                  children: searchedData.map((e) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(
                          builder: (context) {
                            return ProductDetailScreen(
                              productData: e,
                            );
                          },
                        ));
                      },
                      child: Card(
                        child: Row(
                          children: [
                            SizedBox(
                              height: 100,
                              width: 100,
                              child: Image.network(e['imageUrl'][0]),
                            ),
                            const SizedBox(
                              width: 15,
                            ),
                            Column(
                              children: [
                                Text(
                                  e['productName'],
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  e['productPrice'].toString(),
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.yellow[900]),
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                );
              },
            ),
    );
  }
}
