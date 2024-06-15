import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class UnPublishedScreen extends StatelessWidget {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  UnPublishedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> _productsStream = FirebaseFirestore.instance
        .collection('products')
        .where('vendorId', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .where('approved', isEqualTo: false)
        .snapshots();
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
        stream: _productsStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Something went wrong'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
                child: CircularProgressIndicator(
              color: Colors.yellow[900],
            ));
          }

          if (snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text(
                'No Unpublish product Yet',
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),
            );
          }
          return ListView.builder(
            shrinkWrap: true,
            itemCount: snapshot.data!.size,
            itemBuilder: (context, index) {
              final vendorProductData = snapshot.data!.docs[index];
              return Slidable(
                key: const ValueKey(0),

                // The start action pane is the one at the left or the top side.
                startActionPane: ActionPane(
                  // A motion is a widget used to control how the pane animates.
                  motion: const ScrollMotion(),

                  // A pane can dismiss the Slidable.
                  // dismissible: DismissiblePane(onDismissed: () {}),

                  // All actions are defined in the children parameter.
                  children: [
                    // A SlidableAction can have an icon and/or a label.
                    SlidableAction(
                      flex: 2,
                      onPressed: (context) async {
                        await _firestore
                            .collection('products')
                            .doc(vendorProductData['productId'])
                            .update({
                          'approved': true,
                        });
                      },
                      backgroundColor: const Color(0xFF21B7CA),
                      foregroundColor: Colors.white,
                      icon: Icons.approval_sharp,
                      label: 'publish',
                    ),
                    SlidableAction(
                      flex: 2,
                      onPressed: (context) async {
                        await _firestore
                            .collection('products')
                            .doc(vendorProductData['productId'])
                            .delete();
                      },
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      icon: Icons.delete,
                      label: 'Delete',
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Container(
                        height: 80,
                        width: 80,
                        child: Image.network(vendorProductData['imageUrl'][0]),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            vendorProductData['productName'],
                            style: const TextStyle(
                                fontSize: 17, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            '\$' +
                                '' +
                                vendorProductData['productPrice']
                                    .toStringAsFixed(2),
                            style: const TextStyle(
                                fontSize: 17, fontWeight: FontWeight.bold),
                          )
                        ],
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
