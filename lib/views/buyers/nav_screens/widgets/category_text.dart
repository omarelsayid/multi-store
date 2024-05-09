import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class CategoryText extends StatelessWidget {
  CategoryText({super.key});
  final List<String> _categoryLable = [
    'food',
    'vegetable',
    'egg',
    'tea',
    'food',
    'vegetable',
    'egg',
    'tea' 'food',
    'vegetable',
    'egg',
    'tea'
  ];
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(9.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Categoryies',
            style: TextStyle(
              fontSize: 19,
            ),
          ),
          SizedBox(
            height: 40,
            child: Row(
              children: [
                Expanded(
                    child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _categoryLable.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: ActionChip(
                        backgroundColor: Colors.yellow.shade900,
                        onPressed: () {},
                        label: Text(
                          _categoryLable[index],
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    );
                  },
                )),
                IconButton(
                    onPressed: () {}, icon: const Icon(Icons.arrow_forward_ios))
              ],
            ),
          )
        ],
      ),
    );
  }
}
