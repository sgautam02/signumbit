import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/PlaySongController.dart';
import '../../jiosaavn/jiosaavn.dart';
import '../../jiosaavn/models/artist.dart';
import '../../jiosaavn/models/song.dart';
import '../../utils/UniVar.dart';
import '../../widgets/songTile.dart';

class ArtistMoreSong extends StatefulWidget {
  final String artistId;
  const ArtistMoreSong({
    Key? key,
    required this.artistId
  }) : super(key: key);

  @override
  State<ArtistMoreSong> createState() => _ArtistMoreSongState();
}

class _ArtistMoreSongState extends State<ArtistMoreSong>
    with TickerProviderStateMixin {
  late final TabController tabController;
  final jio = JioSaavnClient();
  ScrollController _scrollController = ScrollController();
  var playController = Get.put(PlaySongController());
  RxList<SongResponse> artistSong = <SongResponse>[].obs;
  RxList<SongResponse> songByName = <SongResponse>[].obs;
  int page = 2;

  Future<void> getSong() async {
    ArtistSongResponse songs =
    await jio.artists.artistSongs(widget.artistId, page: page);
    artistSong.addAll(songs.results);
    songByName.addAll(songs.results);
    songByName.sort((a,b)=>a.name!.compareTo(b.name!));
  }

  _scrollListener() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      getSong();
    }
  }

  @override
  void initState() {
    super.initState();
    getSong();
    tabController = TabController(length: 3, vsync: this);
    _scrollController.addListener(_scrollListener);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          TabBar(
            controller: tabController,
            tabs: [
              Text("Popularity"),
              Text("Name"),
              Text("Date"),
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: tabController,
              children: [
                Obx(() => ListView.builder(
                  physics: BouncingScrollPhysics(),
                  shrinkWrap: true,
                  controller: _scrollController,
                  itemCount: artistSong.length,
                  itemBuilder: (context, index) {
                    var song = artistSong[index];
                    return SongTile(
                      song: song,
                      onTap: () {
                        playController.playSong(song, index);
                        UniVar.data=artistSong;
                      },
                    );
                  },
                )),
                Obx(() => ListView.builder(
                  shrinkWrap: true,
                  controller: _scrollController,
                  itemCount: songByName.length,
                  itemBuilder: (context, index) {
                    var song = songByName[index];
                    return SongTile(
                      song: song,
                      onTap: () {
                        playController.playSong(song, index);
                        UniVar.data=songByName;
                      },
                    ).paddingSymmetric(vertical: 10);
                  },
                )),
                // Content for "Date" tab
                Center(
                  child: Text("Date Content"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}


