import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:multi_store/vendors/models/vendor_user_models.dart';
import 'package:multi_store/vendors/views/auth/vendor_rigestraion.dart';
import 'package:multi_store/vendors/views/screens/main_vendor_screen.dart';

class LandingScreen extends StatelessWidget {
  const LandingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final CollectionReference _vendorStream =
        FirebaseFirestore.instance.collection('vendors');
    final FirebaseAuth _auth = FirebaseAuth.instance;
    return Scaffold(
        body: StreamBuilder<DocumentSnapshot>(
      stream: _vendorStream.doc(_auth.currentUser!.uid).snapshots(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator(),);
        }

        if (!snapshot.data!.exists) {
          return const VendorRigestrationScreen();
        }
        VendorUserModel vendorUserModel = VendorUserModel.fromJson(
            snapshot.data!.data() as Map<String, dynamic>);

        if (vendorUserModel.approved == true) {
          return MainVendorScreen();
        }
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  vendorUserModel.storeImage!.toString(),
                  width: 90,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              Text(
                vendorUserModel.bussinessName.toString(),
                style:
                    const TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
              ),
              const Text(
                'Your application has been sent to shop admin \n Admin will get back to you soon',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w400),
                textAlign: TextAlign.center,
              ),
              TextButton(
                  onPressed: () async {
                    await _auth.signOut();
                  },
                  child: const Text('signout'))
            ],
          ),
        );
      },
    ));
  }
}
