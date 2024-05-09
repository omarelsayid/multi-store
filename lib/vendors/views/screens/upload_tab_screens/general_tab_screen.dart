import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:multi_store/provider/product_provider.dart';
import 'package:provider/provider.dart';
import "package:intl/intl.dart";

class GeneralTabScreen extends StatefulWidget {
  const GeneralTabScreen({super.key});

  @override
  State<GeneralTabScreen> createState() => _GeneralTabScreenState();
}

class _GeneralTabScreenState extends State<GeneralTabScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<String> _categoryList = [];
  String? selectedCategory;
  void _getCategories() async {
    QuerySnapshot querySnapshot =
        await _firestore.collection('categroies').get();
    querySnapshot.docs.forEach((doc) {
      _categoryList.add(doc['categoryName']);
    });
    log(_categoryList.toString());
  }

  @override
  void initState() {
    // TODO: implement initState
    _getCategories();
    super.initState();
  }

  String formatedDate(date) {
    final outPutDateFormate = DateFormat('dd/MM/yyyy');
    final outPutDate = outPutDateFormate.format(date);
    return outPutDate;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final ProductProvider _productProvider = Provider.of(context);
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              TextFormField(
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Enter Product Name';
                  } else {
                    return null;
                  }
                },
                onChanged: (value) {
                  _productProvider.getFormData(productName: value);
                },
                decoration:
                    const InputDecoration(labelText: 'Enter the Product Name'),
              ),
              const SizedBox(
                height: 20,
              ),
              TextFormField(
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Enter Product price';
                  } else {
                    return null;
                  }
                },
                onChanged: (value) {
                  _productProvider.getFormData(
                      productPrice: double.parse(value));
                  log('done');
                },
                decoration:
                    const InputDecoration(labelText: 'Enter the product Price'),
              ),
              const SizedBox(
                height: 20,
              ),
              TextFormField(
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Enter Product Quantity';
                  } else {
                    return null;
                  }
                },
                onChanged: (value) {
                  _productProvider.getFormData(quantity: int.parse(value));
                },
                decoration: const InputDecoration(
                    labelText: 'Enter the Product Quantity'),
              ),
              const SizedBox(
                height: 30,
              ),
              DropdownButtonFormField(
                  validator: (value) {
                    if (value == null) {
                      return 'Please Select a Category';
                    } else {
                      return null;
                    }
                  },
                  hint: const Text('Select Category'),
                  items: _categoryList.map<DropdownMenuItem<String>>((e) {
                    
                    return DropdownMenuItem<String>(value: e, child: Text(e));
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _productProvider.getFormData(category: value);
                     
                    });
                  }),
              const SizedBox(
                height: 30,
              ),
              TextFormField(
                validator: (value) {
                  if (value!.isEmpty) {
                    return ' Enter the Product Description';
                  } else {
                    return null;
                  }
                },
                onChanged: (value) {
                  _productProvider.getFormData(description: value);
                },
                maxLength: 800,
                decoration: InputDecoration(
                    labelText: 'Enter Product Description',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10))),
              ),
              Row(
                children: [
                  TextButton(
                      onPressed: () {
                        showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime.now(),
                                lastDate: DateTime(5000))
                            .then((value) {
                          setState(() {
                            _productProvider.getFormData(schedulDate: value);
                          });
                        });
                      },
                      child: const Text(
                        'Schedule',
                        style: TextStyle(color: Colors.lightBlue),
                      )),
                  if (_productProvider.productData['scheduleDate'] != null)
                    Text(formatedDate(
                        _productProvider.productData['scheduleDate']))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
