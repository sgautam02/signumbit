import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sliding_up_panel/flutter_sliding_up_panel.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:html_unescape/html_unescape.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:share_plus/share_plus.dart';
import 'package:SignumBeat/jiosaavn/models/song.dart';
import 'package:SignumBeat/utils/constants.dart';
import 'package:SignumBeat/utils/dimension.dart';
import 'package:SignumBeat/widgets/customCard.dart';
import 'package:SignumBeat/widgets/songTile.dart';
import '../controller/PlaySongController.dart';
import '../utils/AppColor.dart';
import '../utils/UniVar.dart';
import '../widgets/PopupScreens/lyricsPopup.dart';
import '../widgets/popupScreen.dart';
import '../widgets/textWidgets/title.dart';

class MainPlayer extends StatefulWidget {
  final List<dynamic> data;

  MainPlayer({super.key, required this.data});

  @override
  State<MainPlayer> createState() => _MainPlayerState();
}

class _MainPlayerState extends State<MainPlayer> {
  late ScrollController scrollController;
  SlidingUpPanelController panelController = SlidingUpPanelController();
  double minBound = 0;
  double upperBound = 1.0;
  var controller = Get.put(PlaySongController());

  @override
  void initState() {
    scrollController = ScrollController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Scaffold(
          appBar: AppBar(),
          body: Center(
            child: Column(
              children: <Widget>[
                controller.playingModSong.value is SongModel
                    ? songModelWidget()
                    : songResponseWidget(),
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
                              widget.data![controller.playIndex.value - 1],
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
                                    )),
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          if (controller.playIndex.value <
                              widget.data!.length - 1) {
                            controller.playSong(
                              widget.data![controller.playIndex.value + 1],
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
                          lyricPopup(
                              context, controller.playingModSong.value.id);
                        },
                        icon: Icon(Icons.lyrics),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        SlidingUpPanelWidget(
          controlHeight: 60.0,
          anchor: 0.4,
          minimumBound: minBound,
          upperBound: upperBound,
          panelController: panelController,
          onTap: () {
            if (SlidingUpPanelStatus.expanded == panelController.status) {
              panelController.collapse();
            } else {
              panelController.expand();
            }
          },
          enableOnTap: true,
          dragUpdate: (details) {},
          child: Container(
            decoration: ShapeDecoration(
              color: Theme.of(context).cardColor,
              shadows: [
                BoxShadow(
                    blurRadius: 1.0,
                    spreadRadius: 2.0,
                    color: const Color(0x11000000))
              ],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20.0),
                  topRight: Radius.circular(20.0),
                ),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                panelController.status == SlidingUpPanelStatus.dragging
                    ? Icon(Icons.keyboard_arrow_up)
                    : Icon(
                        Icons.horizontal_rule,
                        size: 30,
                      ),
                Text('Next Up'),
                Flexible(
                  child: Container(
                    color: Theme.of(context).cardColor,
                    child: ListView.builder(
                      itemBuilder: (context, index) {
                        var data = UniVar.data;
                        return data is List<SongModel>
                            ? ListTile(
                                leading: QueryArtworkWidget(
                                  id: widget.data![index].id,
                                  type: ArtworkType.AUDIO,
                                  nullArtworkWidget: Icon(
                                    Icons.music_note,
                                    size: Dimension.iconSize(32),
                                  ),
                                ),
                                title: Obx(
                                  () => TextTitle(
                                    text: widget.data![index].displayNameWOExt,
                                  ),
                                ),
                                subtitle: Text(widget.data![index].artist!),
                                trailing: Wrap(
                                  children: [
                                    IconButton(
                                      onPressed: () {
                                        Share.shareUri(Uri.parse(
                                            widget.data![index].uri!));
                                      },
                                      icon: Icon(Icons.share),
                                    ),
                                    IconButton(
                                      onPressed: () {
                                        PopupScreen.menuPopup(
                                            context, widget.data![index]);
                                      },
                                      icon: Icon(Icons.more_vert),
                                    ),
                                  ],
                                ),
                                onTap: () {
                                  controller.playSong(
                                      widget.data[index], index);
                                  UniVar.addRecentSong(widget.data[index]);
                                },
                              )
                            : SongTile(
                                song: widget.data[index],
                                onTap: () {
                                  controller.playSong(
                                      widget.data[index], index);
                                  UniVar.addRecentSong(widget.data[index]);
                                });
                      },
                      itemCount: widget.data.length,
                    ),
                  ),
                ),
              ],
            ),
          ).paddingSymmetric(horizontal: 10),
        ),
      ],
    );
  }

  Widget songModelWidget() {
    return Column(children: <Widget>[
      Container(
          padding: EdgeInsets.all(Dimension.padding(10)),
          height: Dimension.height(400),
          alignment: Alignment.center,
          clipBehavior: Clip.antiAliasWithSaveLayer,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(Dimension.radius(20)),
            shape: BoxShape.rectangle,
          ),
          child: Obx(() {
            if (controller.playingModSong.value is SongResponse) {
              return CustomCard(
                leading: Image(
                  image: NetworkImage(
                      controller.playingModSong.value.downloadUrl.last.link),
                ),
              );
            } else if (controller.playingModSong.value is SongModel) {
              return QueryArtworkWidget(
                id: controller.playingModSong.value != null
                    ? controller.playingModSong.value!.id
                    : 0,
                type: ArtworkType.AUDIO,
                artworkHeight: double.infinity,
                artworkWidth: double.infinity,
                nullArtworkWidget: CircleAvatar(
                    radius: 150, backgroundImage: NetworkImage(appImage)),
                artworkBorder: BorderRadius.circular(Dimension.radius(10)),
                quality: 100,
              );
            } else {
              return CustomCard();
            }
          })),
      Text(
          controller.playingModSong.value != null
              ? controller.playingModSong.value!.displayNameWOExt
              : "SongName",
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
          style: TextStyle(
              fontSize: Dimension.fontSize(15), fontWeight: FontWeight.w600)),
      Text(
          controller.playingModSong.value != null
              ? "${controller.playingModSong.value!.artist}"
              : "artist",
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
          style: TextStyle(
              fontSize: Dimension.fontSize(15), fontWeight: FontWeight.w300)),
    ]);
  }

  Widget songResponseWidget() {
    return Obx(
      () => Column(children: <Widget>[
        Container(
            padding: EdgeInsets.all(Dimension.padding(10)),
            height: Dimension.height(400),
            alignment: Alignment.center,
            clipBehavior: Clip.antiAliasWithSaveLayer,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(Dimension.radius(20)),
              shape: BoxShape.rectangle,
            ),
            child: Obx(() => CustomCard(
                  size: 500,
                  leading: Image(
                    image: controller.playingModSong.value != null
                        ? NetworkImage(
                            controller.playingModSong.value.image.last.link)
                        : NetworkImage(appImage),
                  ),
                ))),
        Text(
            controller.playingModSong.value != null
                ? HtmlUnescape().convert(controller.playingModSong.value!.name)
                : "SongName",
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
            style: TextStyle(
                fontSize: Dimension.fontSize(15), fontWeight: FontWeight.w600)),
        Text(
            controller.playingModSong.value != null
                ? HtmlUnescape()
                    .convert(controller.playingModSong.value!.primaryArtists)
                : "artist",
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
            style: TextStyle(
                fontSize: Dimension.fontSize(15), fontWeight: FontWeight.w300)),
      ]),
    );
  }
}
