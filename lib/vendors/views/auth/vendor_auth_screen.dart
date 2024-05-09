import 'package:firebase_auth/firebase_auth.dart' hide EmailAuthProvider;
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'package:multi_store/vendors/views/screens/landing_screen.dart';


class VendorsAuthScreen extends StatefulWidget {
  const VendorsAuthScreen({super.key});

  @override
  State<VendorsAuthScreen> createState() => _VendorsAuthScreenState();
}

class _VendorsAuthScreenState extends State<VendorsAuthScreen> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      initialData: FirebaseAuth.instance.currentUser,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return SignInScreen(
            providers: [
              EmailAuthProvider(),
            ],
          );
        }
        return const LandingScreen();
      },
    );
  }
}
