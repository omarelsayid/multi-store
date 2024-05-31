import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:multi_store/vendors/views/screens/edit_screen.dart';
import 'package:multi_store/views/buyers/auth/login_screen.dart';
import 'package:multi_store/views/buyers/inner_screens/edit_profile_screen.dart';

class AccountScreen extends StatelessWidget {
  AccountScreen({super.key});
  final FirebaseAuth _auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    CollectionReference users = FirebaseFirestore.instance.collection('buyers');
    return FutureBuilder<DocumentSnapshot>(
      future: users.doc(_auth.currentUser!.uid).get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Center(child: Text("Something went wrong"));
        }

        if (snapshot.hasData && !snapshot.data!.exists) {
          return const Center(child: Text("Document does not exist"));
        }

        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data =
              snapshot.data!.data() as Map<String, dynamic>;
          return Scaffold(
            appBar: AppBar(
              actions: const [
                Padding(
                  padding: EdgeInsets.all(14),
                  child: Icon(Icons.nightlight_outlined),
                )
              ],
              elevation: 2,
              backgroundColor: Colors.yellow.shade900,
              title: const Text(
                'Profile',
                style: TextStyle(
                  color: Colors.white,
                  letterSpacing: 4,
                ),
              ),
              centerTitle: true,
            ),
            body: Column(
              children: [
                const SizedBox(
                  height: 25,
                ),
                Center(
                  child: CircleAvatar(
                    radius: 64,
                    backgroundColor: Colors.yellow.shade900,
                    backgroundImage: NetworkImage(data['profileImage']),
                  ),
                ),
                Text(
                  data['fullName'],
                  style: const TextStyle(
                      fontSize: 17, fontWeight: FontWeight.bold),
                ),
                Text(
                  data['email'],
                  style: const TextStyle(
                      fontSize: 17, fontWeight: FontWeight.bold),
                ),
                InkWell(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(
                      builder: (context) {
                        return  EditProfileScreen(userData: data,);
                      },
                    ));
                  },
                  child: Container(
                    height: 40,
                    width: MediaQuery.sizeOf(context).width - 200,
                    decoration: BoxDecoration(
                        color: Colors.yellow[900],
                        borderRadius: BorderRadius.circular(10)),
                    child: const Center(
                      child: Text(
                        'Edit Profile',
                        style: TextStyle(
                            color: Colors.white,
                            letterSpacing: 4,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                // Padding(
                //   padding: const EdgeInsets.symmetric(horizontal: 50),
                //   child: ElevatedButton(
                //     onPressed: () {},
                //     style: ElevatedButton.styleFrom(
                //       maximumSize: Size(MediaQuery.sizeOf(context).width, 50),
                //       minimumSize: Size(MediaQuery.sizeOf(context).width, 50),
                //       backgroundColor: Colors.yellow.shade900,
                //       shape: RoundedRectangleBorder(
                //         borderRadius: BorderRadius.circular(5),
                //       ),
                //     ),
                //     child: const Text(
                //       'Edit Profile',
                //       style: TextStyle(color: Colors.white),
                //     ),
                //   ),
                // ),
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Divider(
                    thickness: 2,
                    color: Colors.grey,
                  ),
                ),
                const ListTile(
                  leading: Icon(Icons.settings),
                  title: Text('Settings'),
                ),
                const ListTile(
                  leading: Icon(Icons.phone),
                  title: Text('phone'),
                ),
                const ListTile(
                  leading: Icon(CupertinoIcons.cart),
                  title: Text('Cart'),
                ),
                const ListTile(
                  leading: Icon(CupertinoIcons.cart_fill_badge_plus),
                  title: Text('Orders'),
                ),
                ListTile(
                  onTap: () async {
                    await _auth.signOut();
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BuyersLoginScreen(),
                        ));
                  },
                  leading: const Icon(Icons.logout),
                  title: Text(
                    'Logout',
                    style: TextStyle(color: Colors.yellow.shade900),
                  ),
                ),
              ],
            ),
          );
        }

        return const Center(child: Center(child: CircularProgressIndicator()));
      },
    );
  }
}
