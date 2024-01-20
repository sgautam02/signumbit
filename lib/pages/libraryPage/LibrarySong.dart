import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:share_plus/share_plus.dart';
import '../../controller/PlaySongController.dart';
import '../../utils/UniVar.dart';
import '../../utils/dimension.dart';
import '../../widgets/popupScreen.dart';

class LibrarySong extends StatelessWidget {
  LibrarySong({super.key,});

   Dio _dio = Dio();
   Uint8List? _audioBytes;




  @override
  Widget build(BuildContext context) {
    var controller = Get.put(PlaySongController());
    return Scaffold(
      body: Column(
        children: [
          Container(
            height: Dimension.height(50),
            child: const ListTile(
              title: Text("Shuffle playback"),
              leading: Icon(Icons.play_circle),
              trailing: Icon(Icons.shuffle),
            ),
          ),
          Expanded(
            child: FutureBuilder<List<SongModel>>(
              future: controller.audioQuery.querySongs(
                ignoreCase: true,
                orderType: OrderType.ASC_OR_SMALLER,
                sortType: null,
                uriType: UriType.EXTERNAL,
              ),
              builder: (BuildContext context, AsyncSnapshot<List<SongModel>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator()); // or another loading indicator
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else if (snapshot.data == null) {
                  return Text('No data available'); // Handle the case where data is null
                } else {
                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      return Container(
                        margin:  EdgeInsets.all(Dimension.padding(4)),
                        child: ListTile(
                          leading: QueryArtworkWidget(
                            id: snapshot.data![index].id,
                            type: ArtworkType.AUDIO,
                            nullArtworkWidget:  Icon(
                              Icons.music_note,
                              size: Dimension.iconSize(32),
                            ),
                          ),
                          title: Text(snapshot.data![index].displayNameWOExt),
                          subtitle: Text(snapshot.data![index].artist!),
                          trailing: Wrap(
                            spacing: 8.0,
                            children: [
                              IconButton(
                                onPressed: () {
                                  Share.shareUri(Uri.parse(snapshot.data![index].uri!));
                                },
                                icon: Icon(Icons.share),
                              ),
                              IconButton(
                                onPressed: () {
                                  PopupScreen.menuPopup(context,snapshot.data![index]);                                },
                                icon: Icon(Icons.more_vert),
                              ),
                            ],
                          ),
                          onTap: (){
                            controller.playSong(snapshot.data![index], index);
                            UniVar.data =snapshot.data!;
                            UniVar.addRecentSong(snapshot.data![index]);
                            // BottomSheetPlayer.showBottomSheet(context,UniVar.data);
                          },
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
          SizedBox(height: 50,)
        ],
      ),
    );
  }
}
