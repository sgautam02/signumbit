import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:SignumBeat/jiosaavn/models/song.dart';
import 'package:SignumBeat/widgets/customCard.dart';
import 'package:SignumBeat/widgets/textWidgets/subTitle.dart';
import 'package:SignumBeat/widgets/textWidgets/title.dart';

import '../../controller/PlaySongController.dart';
import '../../utils/UniVar.dart';
import '../iconText.dart';

songDetailPopup(BuildContext context,SongResponse song) async {
  var playController = Get.put(PlaySongController());
  showGeneralDialog(
    context: context,
    pageBuilder: (context,animation,secondaryAnimation) => Center(
      child: Material(
        type: MaterialType.transparency,
        child: Container(
          width: 500, // Set your desired width
          height: 900, // Set your desired height
          child: Stack(
            children: [
              Positioned(
                top:80,
                child: Column(
                  children: [
                    Container(
                      height: 450,
                      width: 370,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Theme.of(context).cardColor
                      ),
                      child: Column(
                        children: [
                          SizedBox(height:70,),
                          Column(
                            children: [
                              TextTitle(text: song.name.toString(),fontSize: 20,),
                              SubTitle(text: song.primaryArtists,fontSize: 16,)
                            ],
                          ),
                           Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              IconText(
                                text: 'Play now',
                                icon: CupertinoIcons.play,
                                onTap: ()=>playController.playSong(song, 0),
                              ),
                              IconText(
                                text: 'Play next',
                                icon: Icons.queue_play_next,
                                onTap: (){
                                  UniVar.data.add(song);
                                }
                              ),
                              IconText(
                                text: 'Mark to Favourite',
                                icon: CupertinoIcons.heart,
                                onTap: (){
                                  UniVar.favouriteSong.add(song);
                                  Fluttertoast.showToast(msg: 'Added to favourite');
                                },
                              ),
                              IconText(
                                text: 'Add to Playlist',
                                icon:CupertinoIcons.music_note_list,
                              ),
                              IconText(
                                text: 'Add to Queue',
                                icon: Icons.playlist_add_rounded,
                              ),
                              IconText(
                                text: 'Download',
                                icon: CupertinoIcons.arrow_down_to_line,
                              ),
                              IconText(
                                text: 'Share',
                                icon: Icons.share,
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: ()=>Get.back(),
                      child: Container(
                        height: 50,
                        width: 370,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Theme.of(context).cardColor
                        ),
                        child: Center(child: TextTitle(text:"Cancel",fontSize: 20,),),
                      ).paddingOnly(top: 10),
                    )
                  ],
                ),
              ),
              Positioned(
                  top: 0,
                  left: 100,
                  child:CustomCard(
                    leading: Image(image: NetworkImage(song.image!.last.link),),
                  )
              ),
            ],
          ).paddingSymmetric(horizontal: 10),
        ),
      ),
    ),
    transitionBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child) {
      const begin = Offset(1,1);
      const end = Offset(0,0.3);
      const curve = Curves.easeInOut;
      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
      var offsetAnimation = animation.drive(tween);
      return SlideTransition(
        position: offsetAnimation,
        child: child,
      );
    },
    transitionDuration: const Duration(milliseconds: 300),
    barrierLabel: 'Dismiss', // Provide a non-null value for barrierLabel
    barrierDismissible: true,
  );
}