import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:SignumBeat/jiosaavn/jiosaavn.dart';
import 'package:SignumBeat/pages/tileDetails/OnlinePlaylistDetails.dart';
import 'package:SignumBeat/pages/tileDetails/albumDetails.dart';
import 'package:SignumBeat/pages/tileDetails/artistDetail.dart';
import 'package:SignumBeat/pages/tileDetails/songDetails.dart';
import 'package:SignumBeat/utils/UniVar.dart';
import 'package:SignumBeat/utils/dimension.dart';
import 'package:SignumBeat/widgets/customCard.dart';
import 'package:SignumBeat/widgets/textWidgets/title.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';
import '../controller/PlaySongController.dart';
import '../jiosaavn/models/playlist.dart';
import '../jiosaavn/models/search.dart';
import '../jiosaavn/models/song.dart';
import '../widgets/shimmers/songListTileShimmer.dart';
import '../widgets/shimmers/shimmerCard.dart';
import '../widgets/songTile.dart';
import 'Online.dart';

class SearchMusic extends StatefulWidget {
  SearchMusic({Key? key}) : super(key: key);

  @override
  _SearchMusicState createState() => _SearchMusicState();
}

class _SearchMusicState extends State<SearchMusic> with TickerProviderStateMixin{
  TextEditingController searchController = TextEditingController();
  ScrollController scrollController = ScrollController();
  final jio = JioSaavnClient();

  var controller = Get.put(PlaySongController());
  var yt = YoutubeExplode();
  List<SongModel> musicList = [];
  bool isLoading = false;
  int visibleTilesCount = 3;
  bool showAllTiles = false;
  List<SearchPlaylist> playlists=[];
  Future<AllSearchResponse>? search;
  Future<List<SongResponse>>? songs;

  @override
  void initState() {
    super.initState();
  }


  getSearchModule( String query) async {
    Future<AllSearchResponse> all= jio.search.all(query);
    var alls= await all;
    List<String> songIds=alls.songs.results.map((e) => e.id).toList();
    songs = jio.songs.detailsByIds(songIds);
    search= all;
    setState(() {
      search= all;
    });
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
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: SizedBox(
          height: Dimension.height(50),
          child: TextField(
              onSubmitted:(value)=> getSearchModule(value),
              decoration: InputDecoration(
                  filled: true,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(Dimension.width(10)),
                      borderSide: BorderSide.none
                  ),
                  hintText: "Type something here",
                  prefixIcon: Icon(Icons.search)
              ),
              textInputAction: TextInputAction.search
          ),
        ),
      ),
      body:search==null?Online(): SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextTitle(text: "Top results",fontSize: 18,),
            FutureBuilder(
                future: search,
                builder: (c,d){
                  if(d.connectionState==ConnectionState.waiting){
                    return SongListTileShimmer();
                  }else if(d.hasError){
                    return Text(d.error.toString());
                  }else {
                    var data= d.data!.topQuery.results;
                    return SizedBox(
                      height: 150,
                      child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: data.length,
                          itemBuilder: (c,i){
                            var result= data[i];
                            return result.type=='song'?
                            CustomCard(size: 120,
                              onTap: () async =>Get.to(SongDetails(song: await jio.songs.detailsById(result.id))),
                              leading: Image(
                                image: NetworkImage(result.image!.last.link),
                              ),
                              title: Text(result.title),
                            ):
                            CustomCard(
                              onTap: (()=>Get.to(()=>ArtistDetail(artistId:result.id))),
                              size: 100,
                              leading: Image(
                                image: NetworkImage(result.image!.last.link),
                              ),
                              title: Text(result.type),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(100)
                              ),
                            );
                          }
                      ),
                    );
                  }
                }),
            TextTitle(text: "Songs",fontSize: 18,),
            FutureBuilder(
                future: songs,
                builder: (c,d){
                  if(d.connectionState==ConnectionState.waiting){
                    return ShimmerCard();
                  }else if(d.hasError){
                    return Text(d.error.toString());
                  }else if( d.data== null){
                    return Text("No data");
                  }else{
                    var song= d.data!;
                    return SizedBox(
                      height: 230,
                      child: ListView.builder(
                          scrollDirection: Axis.vertical,
                          itemCount: song.length,
                          itemBuilder: (c,i){
                            var result= song[i];
                            return
                              SongTile(
                                song: result,
                                onTap: (){
                                  controller.playSong(result,i);
                                  UniVar.data=song;
                                },
                              );
                          }
                      ),
                    );
                  }
                }),
            TextTitle(text: "Albums",fontSize: 18,),
            FutureBuilder(
                future: search,
                builder: (c,d){
                  if(d.connectionState==ConnectionState.waiting){
                    return ShimmerCard();
                  }else if(d.hasError){
                    return Text(d.error.toString());
                  }else if( d.data== null){
                    return Text("no data available");
                  }else{
                    var data= d.data!.albums.results;
                    return SizedBox(
                      height: 150,
                      child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: data.length,
                          itemBuilder: (c,i){
                            var result= data[i];
                            return
                            CustomCard(size: 120,
                              onTap: ()=>Get.to(()=>AlbumDetails(albumId: result.id,)),
                              leading: Image(
                                image: NetworkImage(result.image!.last.link),
                              ),
                              title: Text(result.title,overflow: TextOverflow.ellipsis,),
                            );
                          }
                      ),
                    );
                  }
                }),
            TextTitle(text: "Artists",fontSize: 18,),
            FutureBuilder(
                future: search,
                builder: (c,d){
                  if(d.connectionState==ConnectionState.waiting){
                    return Container(
                      height: 140,
                      child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount:3,
                          itemBuilder:(c,i){
                            return
                              ShimmerCard();}
                      ),
                    );
                  }else if(d.hasError){
                    return Text(d.error.toString());
                  }else if( d.data== null){
                    return Text("no data available");
                  }else{
                    var data= d.data!.artists.results;
                    return SizedBox(
                      height: 150,
                      child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: data.length,
                          itemBuilder: (c,i){
                            var result= data[i];
                            return
                              CustomCard(size: 120,
                                onTap: () async =>Get.to(ArtistDetail(artistId:result.id ,)),
                                leading: Image(
                                  image: NetworkImage(result.image!.last.link),
                                ),
                                title: Text(result.title,overflow: TextOverflow.ellipsis,),
                              );
                          }
                      ),
                    );
                  }
                }),
            TextTitle(text: "Top Playlists",fontSize: 18,),
            FutureBuilder(
                future: search,
                builder: (c,d){
                  if(d.connectionState==ConnectionState.waiting){
                    return  Container(
                      height: 140,
                      child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount:3,
                          itemBuilder:(c,i){
                            return
                              ShimmerCard();}
                      ),
                    );
                  }else if(d.hasError){
                    return Text(d.error.toString());
                  }else if( d.data== null){
                    return Text("no data available");
                  }else{
                    var data= d.data!.playlists.results;
                    print(data.length);
                    return SizedBox(
                      height: 150,
                      child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: data.length,
                          itemBuilder: (c,i){
                            var result= data[i];
                            print(data.length.toString());
                            return
                              CustomCard(size: 120,
                                onTap:(()=>Get.to(OnlinePlayListDetails(playlistId: result.id))),
                                leading: Image(
                                  image: NetworkImage(result.image!.last.link),
                                ),
                                title: Text(result.title,overflow: TextOverflow.ellipsis,),
                              );
                          }
                      ),
                    );
                  }
                }),
          ],
        ).paddingOnly(left: 10),
      ),
    );

  }
}