import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:multi_store/vendors/views/screens/vendor_inner_screen/withdrawal_screen.dart';

class EarningsScreen extends StatelessWidget {
  const EarningsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    CollectionReference users =
        FirebaseFirestore.instance.collection('vendors');
    final Stream<QuerySnapshot> _ordersStream = FirebaseFirestore.instance
        .collection('orders')
        .where('vendorId', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .snapshots();
    return FutureBuilder<DocumentSnapshot>(
      future: users.doc(FirebaseAuth.instance.currentUser!.uid).get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text("Something went wrong");
        }

        if (snapshot.hasData && !snapshot.data!.exists) {
          return Text("Document does not exist");
        }

        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data =
              snapshot.data!.data() as Map<String, dynamic>;
          return Scaffold(
              appBar: AppBar(
                elevation: 0,
                title: Row(
                  children: [
                    CircleAvatar(
                      backgroundImage: NetworkImage(data['image']),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        // ignore: prefer_interpolation_to_compose_strings
                        'Hi ' + data['bussinessName'],
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          letterSpacing: 6,
                        ),
                      ),
                    )
                  ],
                ),
              ),
              body: StreamBuilder<QuerySnapshot>(
                stream: _ordersStream,
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return Text('Something went wrong');
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Text("Loading");
                  }

                  double totalOrder = 0.0;
                  for (var orderItem in snapshot.data!.docs) {
                    totalOrder +=
                        orderItem['quantity'] * orderItem['productPrice'];
                  }
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(14.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Container(
                            height: 150,
                            width: MediaQuery.sizeOf(context).width * 0.5,
                            decoration: BoxDecoration(
                              color: Colors.yellow[900],
                              borderRadius: BorderRadius.circular(32),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                const Padding(
                                  padding: EdgeInsets.all(10.0),
                                  child: Text(
                                    'TOTAL EARINGS',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Text(
                                    "\$" + " " + totalOrder.toString(),
                                    style: const TextStyle(
                                      letterSpacing: 4,
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                          Container(
                            height: 150,
                            width: MediaQuery.sizeOf(context).width * 0.5,
                            decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.circular(32),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                const Padding(
                                  padding: EdgeInsets.all(10.0),
                                  child: Text(
                                    'TOTAL Orders',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Text(
                                    snapshot.data!.docs.length.toString(),
                                    style: const TextStyle(
                                      letterSpacing: 4,
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.push(context, MaterialPageRoute(
                                builder: (context) {
                                  return  WithdrawalScreen();
                                },
                              ));
                            },
                            child: Container(
                              height: 40,
                              width: MediaQuery.sizeOf(context).width - 40,
                              decoration: BoxDecoration(
                                color: Colors.yellow[900],
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Center(
                                child: Text(
                                  'Withdraw',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 6,
                                  ),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                },
              ));
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
