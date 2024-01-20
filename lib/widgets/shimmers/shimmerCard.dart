import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerCard extends StatelessWidget {
  const ShimmerCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      highlightColor: Colors.white38,
      baseColor: Colors.grey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 100,
            width: 100,
            decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
              color: Colors.grey
            ),
          ),
          Container(
            height: 5,
            width: 80,
            color: Colors.grey,
          ).paddingAll(3),
          Container(
            height: 5,
            width: 50,
            color: Colors.grey,
          )
        ],
      ).paddingAll(10),
    )
    ;
  }
}
