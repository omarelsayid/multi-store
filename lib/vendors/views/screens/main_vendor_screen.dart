import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:multi_store/vendors/views/screens/earnings_screen.dart';
import 'package:multi_store/vendors/views/screens/edit_screen.dart';
import 'package:multi_store/vendors/views/screens/vendor_account_screen.dart';
import 'package:multi_store/vendors/views/screens/vendor_order_screen.dart';
import 'package:multi_store/vendors/views/screens/upload_screen.dart';
import 'package:multi_store/vendors/views/screens/vendor_logout_screen.dart';
import 'package:multi_store/views/buyers/nav_screens/account_screen.dart';
import 'package:multi_store/views/buyers/nav_screens/store_screen.dart';

class MainVendorScreen extends StatefulWidget {
  const MainVendorScreen({Key? key}) : super(key: key);

  @override
  State<MainVendorScreen> createState() => _MainVendorScreenState();
}

class _MainVendorScreenState extends State<MainVendorScreen> {
  int _pageIndex = 0;

  final List<Widget> _pages = [
    const EarningsScreen(),
    UploadScreen(),
    const EditProductScreen(),
    VendorOrderScreen(),
    const VendorAccountScreen()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        onTap: (value) {
          setState(() {
            _pageIndex = value;
            log(_pageIndex.toString());
          });
        },
        currentIndex: _pageIndex,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.yellow.shade900,
        unselectedItemColor: Colors.black,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.money_dollar),
            label: 'EARNINGS',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.upload),
            label: 'UPLOAD',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.edit),
            label: 'EDIT',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.cart),
            label: 'ORDERS',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'ACCOUNT',
          ),
        ],
      ),
      body: _pages[_pageIndex],
    );
  }
}
