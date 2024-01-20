import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:on_audio_query/on_audio_query.dart';
import '../../utils/AppColor.dart';
import '../../utils/UniVar.dart';
import '../../utils/dimension.dart';


class RecentSong extends StatelessWidget {
  const RecentSong({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(leading: GestureDetector(
        onTap: ()=>Get.back(),
          child: Icon(Icons.arrow_back_ios_rounded)),),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: AppColor.mainColor,
                  borderRadius: BorderRadius.circular(Dimension.radius(20))
                ),
                  child: Row(
                    children: [
                      Icon(Icons.play_circle),
                      Text("Play all",style: TextStyle(color: Colors.white),),
                    ],
                  ).paddingAll(Dimension.padding(5))
              ),
              Icon(Icons.delete_forever_outlined)
            ],
          ).paddingOnly(left: Dimension.padding(30),right: Dimension.padding(30)),
          Expanded(
            child: ListView.builder(
                itemCount: UniVar.recentData.length,
                itemBuilder: (ctxt, index){
                  var song = UniVar.recentData[index];
                  return ListTile(
                    leading: QueryArtworkWidget(
                      id: song.id,
                      type: ArtworkType.AUDIO,
                      nullArtworkWidget:  CircleAvatar(
                        radius: Dimension.radius(32),
                        backgroundImage:
                        song.composer != null
                            ? NetworkImage(song.composer!)
                            : null,
                      ),
                    ),
                    title: Text(song.displayNameWOExt),
                    subtitle: Text(song.artist!),

                    onTap: (){
                      // controller.playSong(snapshot.data![index], index);

                    },
                  );
                }
            ),
          )
        ],
      )
    );
  }
}
