import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:multi_store/provider/product_provider.dart';
import 'package:provider/provider.dart';

class ShippingTabScreen extends StatefulWidget {
  const ShippingTabScreen({Key? key}) : super(key: key);

  @override
  State<ShippingTabScreen> createState() => _ShippingTabScreenState();
}

class _ShippingTabScreenState extends State<ShippingTabScreen>
    with AutomaticKeepAliveClientMixin {
 // Add a form key

  bool _chargeShipping = false;
  bool get wantKeepAlive => true;
  @override
  Widget build(BuildContext context) {
    super.build(context);
    ProductProvider _productProvider = Provider.of<ProductProvider>(context);
    return Column(
      children: [
        CheckboxListTile(
          activeColor: Colors.lightBlue[400],
          title: const Text(
            'Charge Shipping',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              letterSpacing: 4,
            ),
          ),
          value: _chargeShipping,
          onChanged: (value) {
            setState(() {
              _chargeShipping = value!;
              _productProvider.getFormData(chargeShippping: _chargeShipping);
            });
          },
        ),
        if (_chargeShipping == true)
          TextFormField(
            validator: (value) {
              if (value!.isEmpty) {
                return 'Enter the Shipping charge';
              } else {
                return null;
              }
            },
            onChanged: (value) {
              _productProvider.getFormData(shippingCart: int.parse(value));
            },
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: 'Shipping Charge'),
          ),
      ],
    );
  }
}
