// FloatingPlayer.dart
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:SignumBeat/utils/constants.dart';
import 'package:SignumBeat/utils/dimension.dart';

import '../controller/PlaySongController.dart';
import '../jiosaavn/models/song.dart';
import '../utils/AppColor.dart';
import '../utils/UniVar.dart';
import 'BottomSheetPlayer.dart';
import 'mainPlayer.dart';

class FloatingPlayer extends StatelessWidget {
  FloatingPlayer({super.key});

  var controller = Get.put(PlaySongController());

  @override
  Widget build(BuildContext context) {
    return Obx(() => controller.playingModSong.value is SongResponse?
        songResponseWidget():songModelWidget()
    );
  }

  Widget songResponseWidget(){
    return Obx(() =>
        SizedBox(
          height: Dimension.height(50),
          width:double.maxFinite,
          child: ElevatedButton(
            onPressed: (()=>Get.to(MainPlayer(data: UniVar.data,))),
            // BottomSheetPlayer.showBottomSheet(context,UniVar.data?.cast<SongModel>())),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Obx(()=>
                    Padding(
                      padding:  EdgeInsets.only(right: Dimension.padding(10)),
                      child: CircleAvatar(
                        radius: Dimension.radius(20),
                        backgroundImage: NetworkImage(controller.playingModSong.value.image.last.link)?? NetworkImage(appImage),
                      )
                    ),
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        controller.playingModSong.value != null
                            ? controller.playingModSong.value!.name
                            : "SongName",
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                      Text(
                        controller.playingModSong.value != null
                            ? "${controller.playingModSong.value.primaryArtists}"
                            : "SongName",
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    IconButton(
                      onPressed: () {
                        if (controller.playIndex.value >0) {
                          controller.playSong(
                            UniVar.data![controller.playIndex.value-1],
                            controller.playIndex.value-1,
                          );
                        } else {
                          Fluttertoast.showToast(
                            msg: 'No next song available',
                            backgroundColor: Colors.grey,
                          );
                        }
                      },
                      icon: Icon(
                        Icons.skip_previous_rounded,
                        size: Dimension.iconSize(40),
                      ),
                    ),
                    CircleAvatar(
                      radius: Dimension.radius(20),
                      child: Transform.scale(
                        scale: 1.5,
                        child: IconButton(
                            onPressed: () {
                              if (controller.isPlaying.value) {
                                controller.audioPlayer.pause();
                                controller.isPlaying(false);
                              } else {
                                controller.audioPlayer.play();
                                controller.isPlaying(true);
                              }
                            },
                            icon: controller.isPlaying.value
                                ? Icon(Icons.pause)
                                :Icon(Icons.play_arrow_rounded,)
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        if (controller.playIndex.value < UniVar.data!.length - 1) {
                          controller.playSong(
                            UniVar.data![controller.playIndex.value+1],
                            controller.playIndex.value + 1,
                          );
                        } else {
                          Fluttertoast.showToast(
                            msg: 'No next song available',
                            backgroundColor: Colors.grey,
                          );
                        }
                      },
                      icon: Icon(
                        Icons.skip_next_rounded,
                        size: Dimension.iconSize(40),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        )

    );
  }
  Widget songModelWidget(){
    return Obx(() =>
        SizedBox(
          height: Dimension.height(50),
          width:double.maxFinite,
          child: ElevatedButton(
            onPressed: (()=>Get.to(MainPlayer(data: UniVar.data,))),
            // BottomSheetPlayer.showBottomSheet(context,UniVar.data?.cast<SongModel>())),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Obx(()=>
                    Padding(
                        padding:  EdgeInsets.only(right: Dimension.padding(10)),
                        child:QueryArtworkWidget(
                          id: controller.playingModSong.value != null
                              ? controller.playingModSong.value!.id
                              : 0,
                          type: ArtworkType.AUDIO,
                          nullArtworkWidget: CircleAvatar(
                              radius: 40,
                              backgroundImage:
                              NetworkImage(appImage)
                          ),
                          quality: 100,
                        )
                    ),
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                          controller.playingModSong.value != null
                              ? controller.playingModSong.value!.displayNameWOExt
                              : "SongName",
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: TextStyle(
                              fontSize: Dimension.fontSize(15),
                              fontWeight: FontWeight.w600)),
                      Text(
                          controller.playingModSong.value != null
                              ? "${controller.playingModSong.value!.artist}"
                              : "artist",
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: TextStyle(
                              fontSize: Dimension.fontSize(15),
                              fontWeight: FontWeight.w300)
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    IconButton(
                      onPressed: () {
                        if (controller.playIndex.value >0) {
                          controller.playSong(
                            UniVar.data![controller.playIndex.value-1],
                            controller.playIndex.value-1,
                          );
                        } else {
                          Fluttertoast.showToast(
                            msg: 'No next song available',
                            backgroundColor: Colors.grey,
                          );
                        }
                      },
                      icon: Icon(
                        Icons.skip_previous_rounded,
                        size: Dimension.iconSize(40),
                      ),
                    ),
                    CircleAvatar(
                      radius: Dimension.radius(20),
                      child: Transform.scale(
                        scale: 1.5,
                        child: IconButton(
                            onPressed: () {
                              if (controller.isPlaying.value) {
                                controller.audioPlayer.pause();
                                controller.isPlaying(false);
                              } else {
                                controller.audioPlayer.play();
                                controller.isPlaying(true);
                              }
                            },
                            icon: controller.isPlaying.value
                                ? Icon(Icons.pause)
                                : Icon(
                              Icons.play_arrow_rounded,
                            )),
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        if (controller.playIndex.value < UniVar.data!.length - 1) {
                          controller.playSong(
                            UniVar.data![controller.playIndex.value+1],
                            controller.playIndex.value + 1,
                          );
                        } else {
                          Fluttertoast.showToast(
                            msg: 'No next song available',
                            backgroundColor: Colors.grey,
                          );
                        }
                      },
                      icon: Icon(
                        Icons.skip_next_rounded,
                        size: Dimension.iconSize(40),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        )

    );
  }
}
