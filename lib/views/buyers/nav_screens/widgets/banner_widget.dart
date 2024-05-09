import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

class BannerWidget extends StatefulWidget {
  BannerWidget({super.key});

  @override
  State<BannerWidget> createState() => _BannerWidgetState();
}

class _BannerWidgetState extends State<BannerWidget> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final List _bannerImage = [];

  getBanners() async {
    return await _firestore
        .collection('Banners')
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((element) {
        _bannerImage.add(element['image']);
        setState(() {
          log(_bannerImage[0].toString());
        });
      });
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getBanners();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10),
      height: 140,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.yellow.shade900,
      ),
      alignment: Alignment.center,
      child: PageView.builder(
          itemCount: _bannerImage.length,
          itemBuilder: (context, index) {
            return ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: CachedNetworkImage(
                imageUrl: _bannerImage[index],
                fit: BoxFit.cover,
                placeholder: (context, url) => Shimmer(
                  duration: const Duration(seconds: 3), //Default value
                  interval: const Duration(
                      seconds: 5), //Default value: Duration(seconds: 0)
                  color: Colors.yellowAccent, //Default value
                  colorOpacity: 0, //Default value
                  enabled: true, //Default value
                  direction: const ShimmerDirection.fromLTRB(), //Default Value
                  child: Container(
                    color: Colors.white,
                  ),
                ),
                errorWidget: (context, url, error) => const Icon(Icons.error),
              ),
            );
          }),
    );
  }
}
