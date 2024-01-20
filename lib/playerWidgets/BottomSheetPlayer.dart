import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sliding_up_panel/flutter_sliding_up_panel.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:SignumBeat/utils/dimension.dart';
import '../controller/PlaySongController.dart';
import '../utils/AppColor.dart';
import '../utils/UniVar.dart';

class BottomSheetPlayer {
  static SlidingUpPanelController slidingUpPanelController= SlidingUpPanelController();
  static void showBottomSheet(BuildContext context, List<SongModel>? data) {
    var controller = Get.put(PlaySongController());
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Stack(
          children: [
            Obx(
              () => Column(
                children: [
                  Container(
                    padding: EdgeInsets.only(top: Dimension.padding(40)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                            onPressed: () {},
                            icon: Icon(Icons.keyboard_arrow_down)),
                        IconButton(
                            onPressed: () {}, icon: Icon(Icons.more_vert))
                      ],
                    ),
                  ),
                  Container(
                    padding:  EdgeInsets.all(Dimension.padding(10)),
                    height: Dimension.height(400),
                    alignment: Alignment.center,
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(Dimension.radius(20)),
                      shape: BoxShape.rectangle,
                    ),
                    child: QueryArtworkWidget(
                      id: controller.playingModSong.value != null
                          ? controller.playingModSong.value!.id
                          : 0,
                      type: ArtworkType.AUDIO,
                      artworkHeight: double.infinity,
                      artworkWidth: double.infinity,
                      nullArtworkWidget: CircleAvatar(
                        radius: 150,
                        backgroundImage:
                            controller.playingModSong.value?.composer != null
                                ? NetworkImage(
                                    controller.playingModSong.value!.composer!)
                                : null,
                      ),
                      artworkBorder: BorderRadius.circular(Dimension.radius(10)),
                      quality: 100,
                    ),
                  ),
                  Text(
                      controller.playingModSong.value != null
                          ? controller.playingModSong.value!.displayNameWOExt
                          : "SongName",
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style:  TextStyle(
                          fontSize: Dimension.fontSize(15), fontWeight: FontWeight.w600)),
                  Text(
                      controller.playingModSong.value != null
                          ? "${controller.playingModSong.value!.artist}"
                          : "artist",
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style:  TextStyle(
                          fontSize: Dimension.fontSize(15), fontWeight: FontWeight.w300)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [Icon(CupertinoIcons.heart)],
                  ).paddingOnly(right: Dimension.padding(20)),
                  Obx(
                    () => Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(controller.position.value),
                        Expanded(
                            child: Slider(
                                thumbColor: AppColor.mainColor,
                                // activeColor: AppColor.sliderColor,
                                min: const Duration(seconds: 0)
                                    .inSeconds
                                    .toDouble(),
                                max: controller.max.value,
                                value: controller.value.value,
                                onChanged: (newValue) {
                                  controller
                                      .changeDurationToSecond(newValue.toInt());
                                  newValue = newValue;
                                })),
                        Text(controller.duration.value)
                      ],
                    ),
                  ),
                  Obx(
                    () => Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        IconButton(
                          onPressed: () {
                            // Handle shuffle
                          },
                          icon: Icon(CupertinoIcons.shuffle),
                        ),
                        IconButton(
                          onPressed: () {
                            print(
                                "Current playIndex========================================================================: ${controller.playIndex.value}");
                            if (controller.playIndex.value > 0) {
                              controller.playSong(
                                data![controller.playIndex.value - 1],
                                controller.playIndex.value - 1,
                              );
                            } else {
                              Fluttertoast.showToast(
                                msg: 'No previous song available',
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
                          backgroundColor: AppColor.mainColor,
                          radius: Dimension.radius(25),
                          child: Transform.scale(
                            scale: 1.8,
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
                                    ),
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            if (controller.playIndex.value < data!.length - 1) {
                              controller.playSong(
                                data![controller.playIndex.value + 1],
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
                        IconButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                var playerController = Get.put(PlaySongController());
                                return AlertDialog(
                                  clipBehavior: Clip.antiAliasWithSaveLayer,
                                  title: Text("Next Up",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: Dimension.fontSize(16)
                                    ),
                                  ),
                                  content: Container(
                                    width: double.maxFinite,
                                    child: ListView.builder(
                                      itemCount: data!.length,
                                        itemBuilder: (cnxt ,index){
                                          return ListTile(
                                            leading: QueryArtworkWidget(
                                              id: data![index].id,
                                              type: ArtworkType.AUDIO,
                                              nullArtworkWidget: CircleAvatar(
                                                radius: Dimension.radius(32),
                                                backgroundImage:
                                                data?[index].composer != null
                                                    ? NetworkImage(data![index].composer!)
                                                    : null,
                                              ),
                                            ),
                                            title: Text(data![index].displayNameWOExt,style: TextStyle(color: playerController.playIndex.value==index?AppColor.mainColor:Colors.black),),
                                            subtitle: data![index].artist!=null?Text(data![index].artist.toString()):Text(data![index].data),
                                            onTap: () {
                                              playerController.playSong(data![index], index);
                                            },
                                          );
                                        }
                                    )
                                  ),
                                );
                              },
                            );

                          },
                          icon: Icon(CupertinoIcons.square_list_fill),
                        ),
                      ],
                    ),
                  ),
                  NextSongList(
                    data: data!,
                    controller: slidingUpPanelController,
                    height: 300,
                    width: 400,
                  )
                 // Column(
                 //   children: data!.map((e) => ListTile(title:Text(e.title.toString()))).toList(),
                 // )
                ],
              ),
            ),
          ],
        );
      },
    );
  }

}

class NextSongList extends StatelessWidget {
  final List<SongModel> data;
  final SlidingUpPanelController controller;
  final double height;
  final double width;

  NextSongList({
    required this.data,
    super.key,
    required this.controller,
    required this.height,
    required this.width
  });

  var playerController = Get.put(PlaySongController());

  @override
  Widget build(BuildContext context) {
    return data==null?Container():
    SlidingUpPanelWidget(
        child:Container(child: Text("next"),),
        controlHeight:height,
        panelController:controller
    );
  }
}
