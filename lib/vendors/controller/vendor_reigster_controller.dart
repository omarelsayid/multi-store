import 'dart:async';
import 'dart:developer';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class VendorController {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Future<String> _uploadVendorImageToStorage(Uint8List? image) async {
    Reference ref =
        await _storage.ref().child('storeIMage').child(_auth.currentUser!.uid);
    UploadTask uploadTask = ref.putData(image!);
    TaskSnapshot snapshot = await uploadTask;
    String downLoadUrl = await snapshot.ref.getDownloadURL();
    return downLoadUrl;
  }

  pickStoreImage(ImageSource source) async {
    final ImagePicker _imagePicker = await ImagePicker();
    XFile? _file = await _imagePicker.pickImage(source: source);

    if (_file != null) {
      log(_file.toString());
      return await _file.readAsBytes();
    } else {
      return print('No Image Selected');
    }
  }

  Future<String?> registerVendor(
    String bussinessName,
    String email,
    String phoneNumber,
    String countryValue,
    String stateValue,
    String cityValue,
    String taxRegister,
    String taxNumber,
    Uint8List? image,
  ) async {
    String? res = 'some error occured';

    try {
      if (bussinessName.isNotEmpty &&
          email.isNotEmpty &&
          phoneNumber.isNotEmpty &&
          countryValue.isNotEmpty &&
          stateValue.isNotEmpty &&
          cityValue.isNotEmpty &&
          taxRegister.isNotEmpty &&
          taxNumber.isNotEmpty &&
          image != null) {
        String storeImage = await _uploadVendorImageToStorage(image);
        await _firestore.collection('vendors').doc(_auth.currentUser!.uid).set({
          'bussinessName': bussinessName,
          'email': email,
          'phoneNumber': phoneNumber,
          'taxNumber': taxNumber,
          'taxOption': taxRegister,
          'cityValue': cityValue,
          'stateValue': stateValue,
          'countryValue': countryValue,
          'image': storeImage,
          'approved': false,
          'vendorId': _auth.currentUser!.uid,
        }).whenComplete(() {
          res = 'sccuess';
        });
      } else {
        res = 'Please fildes must not be empty';
      }
    } catch (e) {
      res = e.toString();
    }
    return res;
  }
}
