import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:multi_store/provider/product_provider.dart';
import 'package:provider/provider.dart';

class AttributesTabScreen extends StatefulWidget {
  const AttributesTabScreen({super.key});

  @override
  State<AttributesTabScreen> createState() => _AttributesTabScreenState();
}

class _AttributesTabScreenState extends State<AttributesTabScreen>
    with AutomaticKeepAliveClientMixin {
  bool _entered = false;
  @override
  bool get wantKeepAlive => true;

  final TextEditingController _sizeController = TextEditingController();
  List<String> _sizeList = [];
  bool _isSvaed = false;
  @override
  Widget build(BuildContext context) {
    super.build(context);
    ProductProvider _productProvider = Provider.of<ProductProvider>(context);
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        children: [
          TextFormField(
            validator: (value) {
              if (value!.isEmpty) {
                return ' Enter  brand Name';
              } else {
                return null;
              }
            },
            onChanged: (value) {
              _productProvider.getFormData(brandName: value);
            },
            decoration: const InputDecoration(
              labelText: 'Brand',
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            children: [
              Flexible(
                child: SizedBox(
                  width: 100,
                  child: TextFormField(
                    validator: (value) {
                      if (value!.isEmpty) {
                        return ' Enter the Product Size';
                      } else {
                        return null;
                      }
                    },
                    controller: _sizeController,
                    onChanged: (value) {
                      setState(() {
                        _entered = true;
                      });
                    },
                    decoration: const InputDecoration(labelText: 'Size'),
                  ),
                ),
              ),
              _entered == true
                  ? ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5)),
                        backgroundColor: Colors.yellow[900],
                        foregroundColor: Colors.white,
                      ),
                      onPressed: () {
                        setState(() {
                          _sizeList.add(_sizeController.text);
                          _sizeController.clear();
                        });
                      },
                      child: const Text('Add'))
                  : const Text('')
            ],
          ),
          if (_sizeList.isNotEmpty)
            SizedBox(
              height: 50,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _sizeList.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          _sizeList.removeAt(index);
                          _productProvider.getFormData(sizeList: _sizeList);
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.yellow[800],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            _sizeList[index],
                            style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          if (_sizeList.isNotEmpty)
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5)),
                backgroundColor: Colors.yellow[900],
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                _productProvider.getFormData(sizeList: _sizeList);
                setState(() {
                  _isSvaed = true;
                });
              },
              child: Text(
                _isSvaed ? 'Saved' : 'Save',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  letterSpacing: 3,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
