import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

class SongListTileShimmer extends StatelessWidget {
  const SongListTileShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      child: Shimmer.fromColors(
        highlightColor: Colors.white,
        baseColor: Colors.grey,
        child: Container(
          margin: EdgeInsets.symmetric(vertical: 7.5),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container(
                height: 50,
                width: 50,
                color: Colors.grey,
              ).paddingOnly(right: 10),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    height: 10,
                    width: 250,
                    color: Colors.grey,
                  ),
                  Container(
                    height: 10,
                    width: 200,
                    color: Colors.grey,
                  ),
                  Container(
                    height: 10,
                    width: 100,
                    color: Colors.grey,
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
