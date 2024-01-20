import 'package:SignumBeat/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/PlaySongController.dart';
import '../jiosaavn/jiosaavn.dart';

class Podcasts extends StatefulWidget {
  final String artistId;
  Podcasts({super.key, required this.artistId});

  @override
  State<Podcasts> createState() => _PodcastsState();
}

class _PodcastsState extends State<Podcasts> {
  final jio = JioSaavnClient();
  var playController = Get.put(PlaySongController());


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body:Container(
          width: 500, // Set your desired width
          height: 600, // Set your desired height
          color: Colors.white,
          child: Stack(
            children: [
              Positioned(
                top:80,
                  child: Column(
                    children: [
                      Container(
                        height: 400,
                        width: 370,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.red
                        ),
                      ),
                      Container(
                        height: 50,
                        width: 370,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color:Colors.red
                        ),
                      ).paddingOnly(top: 10)
                    ],
                  ),
              ),
              Positioned(
                  top: 0,
                  left: 100,
                  child: CircleAvatar(
                      radius: 80,
                      backgroundImage: NetworkImage(appImage)
                  )
              ),
            ],
          ).paddingSymmetric(horizontal: 10),
        ),
    );
  }
}