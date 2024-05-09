import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:multi_store/views/buyers/nav_screens/widgets/banner_widget.dart';
import 'package:multi_store/views/buyers/nav_screens/widgets/category_text.dart';
import 'package:multi_store/views/buyers/nav_screens/widgets/search_input_widget.dart';
import 'package:multi_store/views/buyers/nav_screens/widgets/wlecome_widget.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const WelcomeTextWidegt(),
        const SizedBox(
          height: 10,
        ),
        const SearchInputWidget(),
        BannerWidget(),
        CategoryText()
      ],
    );
  }
}
