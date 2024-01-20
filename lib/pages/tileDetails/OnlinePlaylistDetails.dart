import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/PlaySongController.dart';
import '../../jiosaavn/jiosaavn.dart';
import '../../jiosaavn/models/playlist.dart';
import '../../jiosaavn/models/song.dart';
import '../../utils/UniVar.dart';
import '../../utils/constants.dart';
import '../../widgets/customCard.dart';
import '../../widgets/songTile.dart';
import '../../widgets/textWidgets/heading.dart';
import '../../widgets/textWidgets/subTitle.dart';

class OnlinePlayListDetails extends StatefulWidget {
  String playlistId;

  OnlinePlayListDetails({super.key, required this.playlistId});

  @override
  State<OnlinePlayListDetails> createState() => _OnlinePlayListDetailsState();
}

class _OnlinePlayListDetailsState extends State<OnlinePlayListDetails> {
  final jio = JioSaavnClient();

  Future<PlayListResponse> getPlaylistDetails() async {
    var list = await jio.playlist.detailsById(widget.playlistId);
    List<String> ids = list.songs!.map((e) => e.id).toList();
    var songs = await jio.songs.detailsByIds(ids);
    PlayListResponse playListResponse =
        PlayListResponse(song: songs, playlist: list);
    return playListResponse;
  }

  @override
  Widget build(BuildContext context) {
    var playerController = Get.put(PlaySongController());
    return Scaffold(
        appBar: AppBar(),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FutureBuilder(
                future: getPlaylistDetails(),
                builder:
                    (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text('Error : ${snapshot.error}'),
                    );
                  } else {
                    PlayListResponse res = snapshot.data;
                    var playlist = res.playlist;
                    var songs = res.song;
                    return Column(
                      children: [
                        Center(
                          child: CustomCard(
                            size: 300,
                            leading: Image(
                              image: NetworkImage(
                                playlist.image!.startsWith("http")
                                    ? playlist.image.toString()
                                    : appImage,
                              ),
                            ),
                            title: Heading(text: playlist.name.toString()),
                          ),
                        ),
                        SubTitle(
                            text:
                                '${playlist.followerCount.toString()} Followers - ${playlist.songs!.length.toString()} Songs'),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            IconButton(
                              onPressed: () {},
                              icon: Icon(
                                CupertinoIcons.share,
                                size: 25,
                              ),
                            ),
                            IconButton(
                                onPressed: () {},
                                icon: Icon(
                                  CupertinoIcons.heart,
                                  size: 30,
                                )),
                            IconButton(
                              onPressed: () {},
                              icon: Icon(
                                Icons.play_arrow_rounded,
                                size: 40,
                              ),
                            ),
                          ],
                        ).paddingOnly(right: 20),
                        Container(
                          height: MediaQuery.of(context).size.height - 200,
                          child: ListView.builder(
                            itemCount: songs!.length,
                            itemBuilder: (context, index) {
                              return SongTile(
                                  song: songs[index],
                                  onTap: (){
                                    playerController.playSong(songs[index], index);
                                    UniVar.data=songs;
                                  }
                              );
                            },
                          ),
                        ),
                      ],
                    );
                  }
                },
              )
            ],
          ),
        ));
  }
}

class PlayListResponse {
  PlaylistResponse playlist;
  List<SongResponse> song;

  PlayListResponse({required this.song, required this.playlist});
}
