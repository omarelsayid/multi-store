import 'dart:developer';
import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:multi_store/controllers/auth_conroller.dart';
import 'package:multi_store/utils/show_snak_bar.dart';
import 'package:multi_store/views/buyers/auth/login_screen.dart';
import 'package:multi_store/views/buyers/main_screen.dart';

class buyersRegisterScreen extends StatefulWidget {
  @override
  State<buyersRegisterScreen> createState() => _buyersRegisterScreenState();
}

class _buyersRegisterScreenState extends State<buyersRegisterScreen> {
  final AuthController _authController = AuthController();

  final GlobalKey<FormState> _formKey = GlobalKey();

  late String email;

  late String fullName;

  late String phoneNumber;

  late String password;

  Uint8List? _image;

  bool _isLoading = false;

  _selectGalleryImage() async {
    Uint8List? im = await _authController.pickImage(ImageSource.gallery);
    setState(() {
      _image = im;
    });
  }

  _selectCameraImage() async {
    Uint8List im = await _authController.pickImage(ImageSource.camera);
    setState(() {
      _image = im;
    });
  }

  _signUpUser() async {
    setState(() {
      _isLoading = true;
    });
    if (_formKey.currentState!.validate()) {
      String res = await _authController
          .signUpUsers(email, password, fullName, phoneNumber, _image)
          .whenComplete(() {
        setState(() {
          _isLoading = false;
          _image = null;
          _formKey.currentState!.reset();
        });
      });

      return showSnakBar(
          context, 'Congratulation The Account Has Been Created For You');
    } else {
      setState(() {
        _isLoading = false;
      });
      return showSnakBar(context, 'PLease Fields must not be empty');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Center(
                  child: Text(
                'create custome\'s Account',
                style: TextStyle(fontSize: 20),
              )),
              Stack(
                children: [
                  _image != null
                      ? CircleAvatar(
                          radius: 64,
                          backgroundColor: Colors.yellow.shade900,
                          backgroundImage: MemoryImage(_image!),
                        )
                      : CircleAvatar(
                          radius: 64,
                          backgroundColor: Colors.yellow.shade900,
                          backgroundImage: const NetworkImage(
                              'https://static.vecteezy.com/system/resources/thumbnails/020/765/399/small/default-profile-account-unknown-icon-black-silhouette-free-vector.jpg'),
                        ),
                  Positioned(
                    right: -10,
                    top: 5,
                    child: IconButton(
                      onPressed: () {
                        _selectGalleryImage();
                      },
                      icon: const Icon(
                        CupertinoIcons.photo,
                        color: Colors.black,
                      ),
                    ),
                  )
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'PLease Email must not be empty';
                    } else {
                      return null;
                    }
                  },
                  onChanged: (value) {
                    email = value;
                  },
                  decoration: const InputDecoration(labelText: 'Enter Email'),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'PLease Full Name must not be empty';
                    } else {
                      return null;
                    }
                  },
                  onChanged: (value) {
                    fullName = value;
                  },
                  decoration:
                      const InputDecoration(labelText: 'Enter Full Name'),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'PLease Phone Number must not be empty';
                    } else {
                      return null;
                    }
                  },
                  onChanged: (value) {
                    phoneNumber = value;
                  },
                  decoration:
                      const InputDecoration(labelText: 'Enter Phone Number'),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'PLease Password must not be empty';
                    } else {
                      return null;
                    }
                  },
                  onChanged: (value) {
                    password = value;
                  },
                  decoration:
                      const InputDecoration(labelText: 'Enter Password'),
                ),
              ),
              GestureDetector(
                onTap: () {
                  _signUpUser();
                },
                child: Container(
                  width: MediaQuery.of(context).size.width - 40,
                  height: 50,
                  decoration: BoxDecoration(
                      color: Colors.yellow.shade900,
                      borderRadius: BorderRadius.circular(10)),
                  child: Center(
                    child: _isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
                            'Register',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 19,
                                fontWeight: FontWeight.bold),
                          ),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Alread Have An Account'),
                  TextButton(
                      onPressed: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return LoginScreen();
                        }));
                      },
                      child: const Text('Login'))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
