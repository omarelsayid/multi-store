import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class WithdrawalScreen extends StatelessWidget {
  final TextEditingController amountController = TextEditingController();
  late String amount;
  late String name;
  late String mobile;
  late String bankName;
  late String banckAccountName;
  late String bankAccountNumber;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.yellow[900],
        elevation: 0,
        title: const Text(
          'Withdraw',
          style: TextStyle(
            color: Colors.white,
            letterSpacing: 6,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please Name must Not be Empty';
                  } else {
                    return null;
                  }
                },
                onChanged: (value) {
                  amount = value;
                },
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Amount'),
              ),
              const SizedBox(
                height: 15,
              ),
              TextFormField(
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Mobile must not be empty';
                  } else {
                    return null;
                  }
                },
                onChanged: (value) {
                  name = value;
                },
                keyboardType: TextInputType.text,
                decoration: const InputDecoration(labelText: 'Name'),
              ),
              const SizedBox(
                height: 15,
              ),
              TextFormField(
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please Name must Not be Empty';
                  } else {
                    return null;
                  }
                },
                onChanged: (value) {
                  mobile = value;
                },
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Mobile'),
              ),
              const SizedBox(
                height: 15,
              ),
              TextFormField(
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Bank Name must Not be empty';
                  } else {
                    return null;
                  }
                },
                onChanged: (value) {
                  bankName = value;
                },
                keyboardType: TextInputType.text,
                decoration: const InputDecoration(
                    labelText: 'Bank Name , ect Access Banck'),
              ),
              const SizedBox(
                height: 15,
              ),
              TextFormField(
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please Filed must Not be Empty';
                  } else {
                    return null;
                  }
                },
                onChanged: (value) {
                  banckAccountName = value;
                },
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                    labelText: 'Bank Account Name ,Eg Macalay Famous'),
              ),
              const SizedBox(
                height: 15,
              ),
              TextFormField(
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please Filed must Not be Empty';
                  } else {
                    return null;
                  }
                },
                onChanged: (value) {
                  bankAccountNumber = value;
                },
                keyboardType: TextInputType.number,
                decoration:
                    const InputDecoration(labelText: 'BankAccoount Number'),
              ),
              TextButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    await _firestore
                        .collection('withdrawal')
                        .doc(Uuid().v4())
                        .set({
                          'Amount':amount,
                          'Name':name,
                          'Mobile':mobile,
                          'BankName':bankName,
                          'BankAccountName':banckAccountName,
                          'BankAccountNumber':bankAccountNumber,
                        });
                    log('cool');
                  } else {
                    log('false');
                  }
                },
                child: const Text(
                  'Get Cash',
                  style: TextStyle(fontSize: 18),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
