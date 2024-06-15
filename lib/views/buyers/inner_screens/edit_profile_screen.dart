import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:image_picker/image_picker.dart';
import 'package:multi_store/controllers/auth_conroller.dart';

class EditProfileScreen extends StatefulWidget {
  final dynamic userData;

  const EditProfileScreen({super.key, this.userData});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  AuthController _authController = AuthController();
  updateImage() async {
    Uint8List image = await _authController.pickImage(ImageSource.gallery);

    _image = await _authController.uploadProfileImageToStorage(image);
    setState(() {});
  }

  String? _image;
  final TextEditingController _fullNameController = TextEditingController();

  final TextEditingController _emailController = TextEditingController();

  final TextEditingController _phoneController = TextEditingController();

  final TextEditingController _addressController = TextEditingController();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String? address;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      _fullNameController.text = widget.userData['fullName'];
      _emailController.text = widget.userData['email'];
      _phoneController.text = widget.userData['phoneNumber'];
      _addressController.text = widget.userData['adderss'];
      _image = widget.userData['profileImage'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        backgroundColor: Colors.white,
        title: const Text(
          'Edit Profile',
          style: TextStyle(color: Colors.black, fontSize: 18, letterSpacing: 6),
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              Stack(
                children: [
                  CircleAvatar(
                    radius: 60,
                    backgroundColor: Colors.yellow[900],
                    backgroundImage: NetworkImage(_image!),
                  ),
                  Positioned(
                    right: 0,
                    child: IconButton(
                      onPressed: () {
                        updateImage();
                      },
                      icon: const Icon(CupertinoIcons.photo),
                    ),
                  )
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: _fullNameController,
                  decoration:
                      const InputDecoration(labelText: 'Enter Full Name'),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(labelText: 'Enter Email'),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: _phoneController,
                  decoration: const InputDecoration(labelText: 'Enter phone'),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  onChanged: (value) {
                    address = value;
                  },
                  controller: _addressController,
                  decoration: const InputDecoration(labelText: 'Enter address'),
                ),
              )
            ],
          ),
        ),
      ),
      bottomSheet: InkWell(
        onTap: () async {
          EasyLoading.show(status: 'UPDATING');
          await _firestore
              .collection('buyers')
              .doc(FirebaseAuth.instance.currentUser!.uid)
              .update({
            'adderss': address,
            'fullName': _fullNameController.text,
            'email': _emailController.text,
            'phoneNumber': _phoneController.text,
          }).whenComplete(() {
            EasyLoading.dismiss();
            Navigator.pop(context);
          });
        },
        child: Container(
          margin: const EdgeInsets.all(13),
          height: 40,
          width: MediaQuery.sizeOf(context).width,
          decoration: BoxDecoration(
            color: Colors.yellow[900],
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Center(
            child: Text(
              'UPDATE',
              style: TextStyle(
                  color: Colors.white, fontSize: 18, letterSpacing: 6),
            ),
          ),
        ),
      ),
    );
  }
}
