import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class VendorLogOutScreen extends StatelessWidget {
  VendorLogOutScreen({super.key});
  final FirebaseAuth _auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: TextButton(
          onPressed: () async {
            await _auth.signOut();
          },
          child: Text('signout')),
    );
  }
}
