import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:html_unescape/html_unescape.dart';
import '../../controller/PlaySongController.dart';
import '../../jiosaavn/jiosaavn.dart';
import '../../jiosaavn/models/playlist.dart';
import '../../jiosaavn/models/song.dart';
import '../../utils/UniVar.dart';
import '../../utils/constants.dart';
import '../../utils/dimension.dart';
import '../../widgets/customCard.dart';
import '../../widgets/songTile.dart';
import '../../widgets/textWidgets/subTitle.dart';
import '../../widgets/textWidgets/title.dart';
import 'OnlinePlaylistDetails.dart';
import 'albumDetails.dart';
import 'artistMoreSong.dart';

class ArtistDetail extends StatefulWidget {
  final String artistId;
  ArtistDetail({
    super.key,
    required this.artistId,
  });
  @override
  _ArtistDetailState createState() => _ArtistDetailState();
}

class _ArtistDetailState extends State<ArtistDetail> {
  final jio = JioSaavnClient();
  var playController = Get.put(PlaySongController());

  //568565//3436900

  Rx<Map<String, dynamic>>? artistDetail = RxMap<String, dynamic>().obs;
  Rx<List<PlaylistResponse>>? dedicatedArtistPlaylists =
      RxList<PlaylistResponse>().obs;
  Rx<List<dynamic>>? featuredArtistPlaylist = RxList<dynamic>().obs;
  Rx<List<dynamic>>? latestReleaseAlbum = RxList<dynamic>().obs;
  Rx<List<dynamic>>? topAlbums = RxList<dynamic>().obs;
  Rx<List<SongResponse>>? topSongs = RxList<SongResponse>().obs;

  getArtistDetails() async {
    Map<String, dynamic> artistMap = await jio.artists.detailById(
        widget.artistId);
    artistDetail?.value = RxMap<String, dynamic>.from(artistMap);

    var songs = (artistMap['topSongs'] as List<dynamic>);
    List<String> ids = songs.map((e) => e['id'] as String).toList();
    var topSong = await jio.songs.detailsByIds(ids);
    topSongs?.value.addAll(topSong);
    List<PlaylistResponse> dAplaylist = await Future.wait(
        (artistMap['dedicated_artist_playlist'] as List<dynamic>)
            .map((e) async => await jio.playlist.detailsById(e['id'])));

    dedicatedArtistPlaylists?.value.addAll(dAplaylist);
    var fAPlaylist = artistMap['featured_artist_playlist'] as List<dynamic>;
    featuredArtistPlaylist?.value.addAll(fAPlaylist);
    var lRAlbum = artistMap['latest_release'] as List<dynamic>;
    latestReleaseAlbum?.value.addAll(lRAlbum);
    var tAlbums = artistMap['topAlbums'] as List<dynamic>;
    topAlbums?.value.addAll(tAlbums);
  }

  formatDuration(int second) {
    Duration duration = Duration(seconds: second);
    String twoDigits(int n) {
      if (n >= 10) return "$n";
      return "0$n";
    }
  }

    @override
    void initState() {
      getArtistDetails();
      super.initState();
    }


    @override
    Widget build(BuildContext context) {
      return Obx(
            () =>
            Scaffold(
              body: artistDetail!.value.isNotEmpty &&
                  topSongs!.value.isNotEmpty &&
                  topAlbums!.value.isNotEmpty
                  ? CustomScrollView(
                  physics: const BouncingScrollPhysics(
                      parent: AlwaysScrollableScrollPhysics()),
                  slivers: <Widget>[
                    SliverAppBar(
                      flexibleSpace: Container(
                        height: 300,
                        child: Stack(
                          children: [
                            ClipPath(
                              clipper: DigonalClip(),
                              child: FlexibleSpaceBar(
                                collapseMode: CollapseMode.pin,
                                background: Stack(
                                  fit: StackFit.expand,
                                  children: <Widget>[
                                    Image.network(
                                      artistDetail!.value['image'] ?? appImage,
                                      fit: BoxFit.cover,
                                    ),
                                    const DecoratedBox(
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          begin: Alignment.bottomCenter,
                                          // Adjusted for vertical gradient// Adjusted for vertical gradient
                                          colors: <Color>[
                                            Color(0xDD000000),
                                            Color(0x00000000),
                                          ],
                                        ),
                                      ),
                                    ),

                                  ],
                                ),
                              ),
                            ),
                            FlexibleSpaceBar(
                              title: Wrap(
                                direction: Axis.vertical,
                                children: [
                                  Text(
                                    artistDetail!.value['name'].toString(),
                                    style: TextStyle(
                                      fontSize: 25,
                                    ),
                                  ),
                                  TextTitle(text: "${artistDetail!
                                      .value['follower_count']} fans",
                                    fontSize: 10,),
                                ],
                              ),
                            ),
                            Positioned(
                                bottom: 10,
                                right: 20,
                                child: Wrap(
                                  spacing: 10,
                                  children: [
                                    CircleAvatar(
                                      radius: Dimension.radius(20),
                                      child: Transform.scale(
                                        scale: 1,
                                        child: IconButton(
                                          onPressed: () {},
                                          icon: Icon(
                                            CupertinoIcons.heart,
                                            color: Theme
                                                .of(context)
                                                .primaryColor,
                                          ),
                                        ),
                                      ),
                                    ),
                                    CircleAvatar(
                                      radius: Dimension.radius(20),
                                      child: Transform.scale(
                                        scale: 1.5,
                                        child: IconButton(
                                            onPressed: () {
                                              playController.playSong(
                                                  topSongs!.value.first, 1);
                                              UniVar.data = topSongs!.value;
                                            },
                                            icon: Icon(
                                              Icons.play_arrow_outlined,
                                              color: Theme
                                                  .of(context)
                                                  .primaryColor,)
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                            ),
                          ],
                        ),
                      ),
                      expandedHeight: 300,
                      pinned: true,
                    ),
                    SliverToBoxAdapter(
                      child: TextTitle(
                        text: 'Top Songs',
                        fontSize: 18,
                      ).paddingOnly(left: 10),
                    ),
                    SliverList(
                      delegate: SliverChildBuilderDelegate(
                            (context, index) {
                          var song = topSongs!.value[index];
                          return SongTile(song: song, onTap: () {});
                        },
                        childCount: 3,
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: GestureDetector(
                        onTap: () =>
                            Get.to(() =>
                                ArtistMoreSong(
                                  artistId: widget.artistId,
                                )),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('More songs'),
                            Icon(Icons.navigate_next)
                          ],
                        ).paddingSymmetric(horizontal: 20, vertical: 10),
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: TextTitle(
                        text: 'Top Albums',
                        fontSize: 18,
                      ).paddingOnly(left: 10),
                    ),
                    SliverToBoxAdapter(
                      child: SizedBox(
                        height: 200,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: topAlbums!.value.length,
                          itemBuilder: (context, index) {
                            var album = topAlbums!.value[index];
                            return CustomCard(
                              size: 180,
                              leading: Image(
                                image: NetworkImage(album['image']),
                              ),
                              title: TextTitle(
                                text: album['title'],
                                overflow: TextOverflow.ellipsis,
                              ),
                              subTitle: SubTitle(
                                text: album['subtitle'],
                                overflow: TextOverflow.ellipsis,
                              ),
                              onTap: () =>
                                  Get.to(() =>
                                      AlbumDetails(
                                        albumId: album['id'],
                                      )),
                            );
                          },
                        ),
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: TextTitle(
                        text: 'Top Playlist',
                        fontSize: 18,
                      ).paddingOnly(left: 10),
                    ),
                    SliverToBoxAdapter(
                      child: SizedBox(
                        height: 190,
                        child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            shrinkWrap: true,
                            itemCount: dedicatedArtistPlaylists!.value.length,
                            itemBuilder: (c, i) {
                              var playlist = dedicatedArtistPlaylists!.value[i];
                              return CustomCard(
                                size: 170,
                                leading: Image(
                                  image: playlist.image.toString().startsWith("https://")?NetworkImage(playlist.image):NetworkImage(appImage),
                                ),
                                title: TextTitle(
                                  text: playlist.name.toString(),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                onTap: () =>
                                    Get.to(OnlinePlayListDetails(
                                        playlistId: playlist.id.toString())),
                              ).paddingSymmetric(horizontal: 5);
                            }),
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: TextTitle(
                        text: 'Featured',
                        fontSize: 18,
                      ).paddingOnly(left: 10),
                    ),
                    SliverToBoxAdapter(
                      child: SizedBox(
                        height: 190,
                        child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            shrinkWrap: true,
                            itemCount: featuredArtistPlaylist!.value.length,
                            itemBuilder: (c, i) {
                              var playlist = featuredArtistPlaylist!.value[i];
                              return CustomCard(
                                size: 180,
                                leading: Image(
                                  image: NetworkImage(playlist['image']),
                                ),
                                title: TextTitle(
                                  text: playlist['title'],
                                  overflow: TextOverflow.ellipsis,
                                ),
                                onTap: () =>
                                    Get.to(OnlinePlayListDetails(
                                        playlistId: playlist['id'])),
                              );
                            }),
                      ),
                    ),
                    SliverToBoxAdapter(
                        child: TextTitle(text: HtmlUnescape().convert(
                            artistDetail!.value['bio']),)
                    ),

                  ]
              )
                  : const Center(
                child: CircularProgressIndicator(),
              ),
            ),
      );
    }
  }
class DigonalClip extends CustomClipper<Path> {
  var radius=5.0;
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0.0, size.height-20);
    path.lineTo(size.width, size.height-70);
    path.lineTo(size.width, 0.0);

    return path;
  }
  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
