import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:multi_store/vendors/views/screens/vendorProductDetail/store_detail_screen.dart';

class StoreScreen extends StatefulWidget {
  const StoreScreen({super.key});

  @override
  State<StoreScreen> createState() => _StoreScreenState();
}

class _StoreScreenState extends State<StoreScreen> {
  final Stream<QuerySnapshot> _vendorsStream =
      FirebaseFirestore.instance.collection('vendors').snapshots();
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _vendorsStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Text("Loading");
        }

        return ListView.builder(
          shrinkWrap: true,
          itemCount: snapshot.data!.size,
          itemBuilder: (context, index) {
            final storeData = snapshot.data!.docs[index];
            return GestureDetector(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(
                  builder: (context) {
                    return StoreDetailScreen(
                      storeData: storeData,
                    );
                  },
                ));
              },
              child: ListTile(
                title: Text(storeData['bussinessName']),
                subtitle: Text(storeData['countryValue']),
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(storeData['image']),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
