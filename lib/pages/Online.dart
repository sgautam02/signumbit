import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:SignumBeat/jiosaavn/jiosaavn.dart';
import 'package:SignumBeat/jiosaavn/models/playlist.dart';
import 'package:SignumBeat/jiosaavn/models/song.dart';
import 'package:SignumBeat/pages/tileDetails/OnlinePlaylistDetails.dart';
import 'package:SignumBeat/utils/UniVar.dart';
import 'package:SignumBeat/widgets/textWidgets/heading.dart';
import 'package:SignumBeat/widgets/textWidgets/subTitle.dart';
import 'package:SignumBeat/widgets/textWidgets/title.dart';
import '../controller/PlaySongController.dart';
import '../utils/constants.dart';
import '../widgets/customCard.dart';
import 'tileDetails/artistDetail.dart';

class Online extends StatefulWidget {
  Online({Key? key}) : super(key: key);

  @override
  State<Online> createState() => _OnlineState();
}

class _OnlineState extends State<Online> {
  List<Map<String, dynamic>> searchResults = [];
  final jio = JioSaavnClient();
  var controller = PlaySongController();

  @override
  void initState() {
    super.initState();
  }

  Future<List<dynamic>?> getChart() {
    var module = jio.module.getChart();
    return module;
  }

  Future<List<PlaylistResponse>?> getTopPlaylists() async {
    var module = await jio.module.getTopPlaylist();
    List<Future<PlaylistResponse>>? playlistFutures =
        module?.map((e) => jio.playlist.detailsById(e)).toList();

    if (playlistFutures == null || playlistFutures.isEmpty) {
      return null;
    }
    List<PlaylistResponse> playlists = await Future.wait(playlistFutures);
    return playlists;
  }

  Future<List?> getArtist() {
    return jio.module.getArtist();
  }

  Future<List<SongResponse>> weeklyTopSongList() async {
    var module = await jio.module.getGlobalConfig();
    var weeklyTopSongsListId =
        module?['weekly_top_songs_listid']['hindi']['listid'];
    PlaylistResponse playlist =
        await jio.playlist.detailsById(weeklyTopSongsListId);
    var ids = playlist.songs?.map((e) => e.id).toList();
    var songs = await jio.songs.detailsByIds(ids!);
    return songs;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Heading(
              text: 'Top Songs',
            ),
            FutureBuilder(
              future: weeklyTopSongList(),
              builder: (context, snapshot) {
                var songs = snapshot.data;
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.hasError) {
                  print(snapshot.error);
                  return Center(child: Text("Error:${snapshot.error}"));
                } else if (songs == null) {
                  // Handle the case where data is null
                  return Text('No data available');
                } else {
                  return Wrap(
                    children: <Widget>[
                      SizedBox(
                        height: 200,
                        width: double.infinity,
                        child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: songs.length,
                            itemBuilder: (context, i) {
                              return CustomCard(
                                onTap: () {
                                  controller.playSong(songs[i], i);
                                  // controller.playSong(songs[i], i);
                                  UniVar.data = songs;
                                },
                                title: TextTitle(
                                    text: (songs[i].name?.toString() ?? 'N/A')
                                        .split('(')
                                        .first,
                                    overflow: TextOverflow.ellipsis),
                                leading: Image(
                                  image: NetworkImage(
                                    songs[i].image!.last.link.toString(),
                                  ),
                                ),
                                subTitle: SubTitle(
                                  text: songs[i].primaryArtists,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              );
                            }),
                      ),
                    ],
                  );
                }
              },
            ),
            Heading(
              text: 'Top Charts',
            ),
            FutureBuilder(
              future: getChart(),
              builder: (context, data) {
                var chart = data.data;
                return data.hasData
                    ? Wrap(
                        children: <Widget>[
                          SizedBox(
                            height: 200,
                            width: double.infinity,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: chart?.length,
                              itemBuilder: (context, index) {
                                return CustomCard(
                                  onTap: () => Get.to(OnlinePlayListDetails(
                                      playlistId: chart[index]['id'])),
                                  title: TextTitle(
                                    text: chart![index]['title'],
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  leading: Image(
                                      image:
                                          NetworkImage(chart[index]['image'])),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.zero),
                                );
                              },
                            ),
                          )
                        ],
                      )
                    : const Center(child: Text("No data found"));
              },
            ),
            Heading(
              text: 'Recommended Artists ',
            ),
            FutureBuilder(
              future: getArtist(),
              builder: (context, data) {
                if (data.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (data.hasError) {
                  return Center(
                    child: Text(
                      'Error!',
                    ),
                  );
                }
                if (!data.hasData) {
                  return Center(
                    child: Text(
                      'Nothing Found!',
                    ),
                  );
                }
                var artist = data.data;
                return Wrap(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 7,
                      ),
                      child: SizedBox(
                        height: 170,
                        width: double.infinity,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          shrinkWrap: true,
                          addAutomaticKeepAlives: false,
                          addRepaintBoundaries: false,
                          physics: const BouncingScrollPhysics(),
                          itemCount: artist?.length,
                          itemBuilder: (context, index) {
                            return CustomCard(
                              onTap: () => Get.to(() => ArtistDetail(
                                    artistId: artist[index]['id'],
                                  )),
                              title: TextTitle(
                                text: artist![index]['title'],
                                overflow: TextOverflow.ellipsis,
                              ),
                              leading: Image(
                                image: artist[index]['image']
                                        .toString()
                                        .startsWith("http")
                                    ? NetworkImage(artist[index]['image'])
                                    : NetworkImage(appImage),
                              ),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(80)),
                            );
                          },
                        ),
                      ),
                    )
                  ],
                );
              },
            ),
            Heading(
              text: 'Top Playlist',
            ),
            FutureBuilder(
              future: getTopPlaylists(),
              builder: (c, data) {
                var playlists = data.data;
                if (data.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (data.hasError) {
                  return Text('error${data.error}');
                } else {
                  return Wrap(
                    children: <Widget>[
                      SizedBox(
                        height: 170,
                        width: double.infinity,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: playlists?.length,
                          itemBuilder: (c, index) {
                            return CustomCard(
                              onTap: () => Get.to(OnlinePlayListDetails(
                                  playlistId: playlists![index].id.toString())),
                              title: TextTitle(
                                text: playlists![index].name.toString(),
                                overflow: TextOverflow.ellipsis,
                              ),
                              leading: Image(
                                image: NetworkImage(
                                  playlists![index].image!.startsWith("http")
                                      ? playlists[index].image.toString()
                                      : appImage,
                                ),
                              ),
                              // subTitle:SubTitle(text: songs[i].primaryArtists,overflow: TextOverflow.ellipsis,),
                            );
                          },
                        ),
                      )
                    ],
                  );
                }
              },
            ),
            SizedBox(
              height: 50,
            )
          ],
        ),
      ),
    );
  }
}
