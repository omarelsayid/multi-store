import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class AuthController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  pickImage(ImageSource source) async {
    final ImagePicker _imagePicker = await ImagePicker();
    XFile? _file = await _imagePicker.pickImage(source: source);
    if (_file != null) {
      return await _file.readAsBytes();
    } else {
      print('no image picked');
    }
  }

  Future<String> uploadProfileImageToStorage(Uint8List? image) async {
    Reference ref =
        _storage.ref().child('profilePics').child(_auth.currentUser!.uid);

    UploadTask uploadTask = ref.putData(image!);
    TaskSnapshot snapshot = await uploadTask;
    String downLoadUrl = await snapshot.ref.getDownloadURL();
    return downLoadUrl;
  }

  Future<String> signUpUsers(String email, String password, String fullName,
      String phoneNumber, Uint8List? image) async {
    String res = 'some error occured';
    try {
      if (email.isNotEmpty &&
          password.isNotEmpty &&
          fullName.isNotEmpty &&
          phoneNumber.isNotEmpty &&
          image != null) {
        UserCredential cred = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);
        String pofileImageUrl = await uploadProfileImageToStorage(image!);

        await _firestore.collection('buyers').doc(cred.user!.uid).set({
          'email': email,
          'fullName': fullName,
          'phoneNumber': phoneNumber,
          'buyerId': cred.user!.uid,
          'adderss': '',
          'profileImage': pofileImageUrl
        });
        res = 'scuccess';
      } else {
        res = 'Please Fields must not be empty';
      }
    } catch (e) {}
    return res;
  }

  Future<String> loginUsers(String email, String password) async {
    String res = 'somthig went worng';

    try {
      if (email.isNotEmpty && password.isNotEmpty) {
        await _auth.signInWithEmailAndPassword(
            email: email, password: password);
        res = 'success';
      } else {
        res = 'please fileds must not be empty';
      }
    } catch (e) {
      res = e.toString();
    }
    return res;
  }
}
