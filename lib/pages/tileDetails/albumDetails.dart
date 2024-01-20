import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/PlaySongController.dart';
import '../../jiosaavn/jiosaavn.dart';
import '../../jiosaavn/models/album.dart';
import '../../utils/UniVar.dart';
import '../../widgets/customCard.dart';
import '../../widgets/songTile.dart';
import '../../widgets/textWidgets/subTitle.dart';
import '../../widgets/textWidgets/title.dart';

class AlbumDetails extends StatefulWidget {
  final albumId;
  const AlbumDetails({
    super.key,
    required this.albumId
  });

  @override
  State<AlbumDetails> createState() => _AlbumDetailsState();
}

class _AlbumDetailsState extends State<AlbumDetails> {
  var jio= JioSaavnClient();
  AlbumResponse? albumDetails;
  var controller = PlaySongController();


  @override
  void initState() {
    getAlbum();
    super.initState();
  }

  getAlbum() async {
    albumDetails= await jio.albums.detailsById(widget.albumId);

    setState(() {

    });
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(),
      body: albumDetails!=null?
      SingleChildScrollView(
        child: Column(
          children: [
            Center(
              child: CustomCard(
                size: 250,
                leading: Image(
                  image: NetworkImage(albumDetails!.image!.last.link),
                ),
                title: TextTitle(text: albumDetails!.name.toString(), overflow: TextOverflow.ellipsis,),
                subTitle: SubTitle(text: albumDetails!.primaryArtists.map((e) => e.name).toList().toString(),overflow: TextOverflow.ellipsis),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  onPressed: ()  async {

                    try{
                      // await Share.shareUri(Uri.parse(widget.song.downloadUrl!.last.link));
                    }catch(e){
                      print(e);
                    }
                  },
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
                  onPressed: () {
                    controller.playSong(albumDetails!.songs.first,1);
                    UniVar.data=albumDetails!.songs;
                  },
                  icon: Icon(
                    Icons.play_arrow_rounded,
                    size: 40,
                  ),
                ),
              ],
            ).paddingOnly(right: 20),
            Wrap(
              direction: Axis.vertical,
              children: albumDetails!.songs.asMap().entries.map((entry) {
                final index = entry.key;
                final song = entry.value;
                return SongTile(
                  song: song,
                  onTap: () {
                    controller.playSong(song,index);
                    UniVar.data=albumDetails!.songs;
                  },
                );
              }).toList(),
            ),
            Container(
              height: 100,
              width: double.infinity,
              child: ListView.builder(
                itemCount: albumDetails!.primaryArtists.length,
                  itemBuilder: (c,i){
                   var pArist = albumDetails!.primaryArtists[i];
                    return
                        CustomCard(
                          leading:Image(image: NetworkImage(pArist.image!.last.link),) ,
                        );
                  }
              ),
            )
      ],
        )
      )
          :Center(child: CircularProgressIndicator(),),
    );
  }
}
