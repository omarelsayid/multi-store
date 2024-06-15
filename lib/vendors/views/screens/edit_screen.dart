import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:multi_store/vendors/views/screens/edit_product_tabs/published_tabs.dart';
import 'package:multi_store/vendors/views/screens/edit_product_tabs/unpublished_tabs.dart';

class EditProductScreen extends StatelessWidget {
  const EditProductScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          centerTitle: true,
          title: const Text(
            'Manage produts',
            style: TextStyle(
              letterSpacing: 7,
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor: Colors.yellow[900],
          bottom: const TabBar(tabs: [
            Tab(
              child: Text('Published'),
            ),
            Tab(
              child: Text('Unpublished'),
            ),
          ]),
        ),
        body: TabBarView(children: [PublishTabScreen(), UnPublishedScreen()]),
      ),
    );
  }
}
