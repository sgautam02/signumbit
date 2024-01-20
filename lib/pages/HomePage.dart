import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/PlaySongController.dart';
import '../jiosaavn/jiosaavn.dart';
import '../jiosaavn/models/song.dart';
import 'libraryPage/AlbumPage.dart';
import 'libraryPage/ArtistPage.dart';
import 'libraryPage/LibrarySong.dart';
import '../utils/dimension.dart';
import 'topicWiseSong/DailyMix.dart';
import 'topicWiseSong/Favourite.dart';
import 'topicWiseSong/PlayListPage.dart';
import 'topicWiseSong/RecentPlayedSong.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  late final TabController _tabController;
  final jiosaavan = JioSaavnClient();

  List<String> topic = ["Recent", "Daily mix", "Favourites", "Playlists"];
  var topicPage = [
    RecentSong(),
    DailMix(),
    Favourite(),
    PlayListPage(),
  ];

  List<Icon> topicIcon = [
    Icon(CupertinoIcons.clock, color: Colors.white),
    Icon(Icons.calendar_today, color: Colors.white),
    Icon(CupertinoIcons.heart, color: Colors.white),
    Icon(CupertinoIcons.music_albums, color: Colors.white),
  ];

  List<List<Color>> tileColor = [
    [Colors.blue, Colors.blue.shade100],
    [Colors.purple, Colors.purple.shade100],
    [Colors.teal, Colors.teal.shade100],
    [Colors.green, Colors.green.shade100],
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<List<SongResponse>> getSong(List<String> ids) async {
    var song = await jiosaavan.songs.detailsByIds(ids);
    return song;
  }

  Future<Future<List<SongResponse>>> getPlaylist() async {
    var playlist = await jiosaavan.playlist.detailsById("114107255");
    var ids = playlist.songs?.map((e) => e.id).toList();
    var songs = getSong(ids!);
    var module = await jiosaavan.module.getModules();
    module.charts?.forEach((e) {});
    return songs;
  }

  @override
  Widget build(BuildContext context) {
    var controller = PlaySongController();

    return Scaffold(
      body: Column(
        children: [
          SizedBox(
            height: Dimension.height(100),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 4,
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(
                  onTap: () => Get.to(
                    topicPage[index],
                    transition: Transition.leftToRight,
                  ),
                  child: Container(
                    width: Dimension.width(150),
                    padding: EdgeInsets.only(left: Dimension.padding(20)),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(Dimension.radius(10)),
                        bottomRight: Radius.circular(Dimension.radius(10)),
                      ),
                      gradient: LinearGradient(
                        begin: Alignment.topRight,
                        end: Alignment.bottomLeft,
                        colors: tileColor[index],
                      ),
                    ),
                    margin: EdgeInsets.all(Dimension.margin(4)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        topicIcon[index],
                        Text(topic[index]),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          TabBar(
            controller: _tabController,
            tabs: [
              Text("Songs"),
              Text("Artist"),
              Text("Albums"),
              Text("Folder"),
            ],
          ),
          Expanded(
            child: DefaultTabController(
              length: 4,
              child: Scaffold(
                body: TabBarView(
                  controller: _tabController,
                  children: [
                    LibrarySong(),
                    ArtistPage(),
                    AlbumPage(),
                    FutureBuilder(
                      future: getPlaylist(),
                      builder: (BuildContext context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return Center(
                              child: Text('Error: ${snapshot.error}'));
                        } else if (snapshot.data == null) {
                          return Center(child: Text('No data available'));
                        } else {
                          return FutureBuilder(
                              future: snapshot.data,
                              builder: (c, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return Center(
                                      child: CircularProgressIndicator());
                                } else if (snapshot.hasError) {
                                  return Center(
                                      child: Text('Error: ${snapshot.error}'));
                                } else if (snapshot.data == null) {
                                  return Center(
                                      child: Text('No data available'));
                                } else {
                                  var songs = snapshot.data;
                                  return ListView.builder(
                                    itemCount: songs?.length,
                                    itemBuilder: (c, i) {
                                      return ListTile(
                                        title: Text(songs![i].name.toString()),
                                        subtitle: Text(songs[i]
                                            .downloadUrl!
                                            .first
                                            .link
                                            .toString()),
                                        leading: CircleAvatar(
                                            radius: Dimension.radius(32),
                                            backgroundImage: NetworkImage(
                                                songs[i]
                                                    .image!
                                                    .first
                                                    .link
                                                    .toString())),
                                        onTap: () => controller.play(songs[i]
                                            .downloadUrl!
                                            .first
                                            .link
                                            .toString()),
                                      );
                                    },
                                  );
                                }
                              });
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/*ListView.builder(
                            itemCount: songs?.length,
                            itemBuilder: (c, i) {
                              return ListTile(
                                title: Text(songs[i].name.toString()),
                                subtitle: Text(songs[i].downloadUrl!.first.link.toString()),
                                onTap: ()=>controller.play(songs[i].downloadUrl!.first.link.toString(), i),
                              );
                            },
                          );*/
