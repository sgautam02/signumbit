import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import '../../controller/PlaySongController.dart';
import '../../jiosaavn/jiosaavn.dart';
import '../../jiosaavn/models/lyrics.dart';
import '../../jiosaavn/models/song.dart';
import '../../widgets/PopupScreens/lyricsPopup.dart';
import '../../widgets/customCard.dart';
import '../../widgets/textWidgets/subTitle.dart';
import '../../widgets/textWidgets/title.dart';

class SongDetails extends StatefulWidget {
  SongResponse song;
  SongDetails({
    super.key,
    required this.song
  });

  @override
  State<SongDetails> createState() => _SongDetailsState();
}

class _SongDetailsState extends State<SongDetails> {
  final jio = JioSaavnClient();
  var controller = PlaySongController();
  final ScrollController _lyricsScrollController = ScrollController();
  double _currentPosition = 0.0;

  Dio _dio = Dio();
  Uint8List? _audioBytes;

  Future<LyricsResponse> getLyrics(songId) async {
    var lyrics = await jio.lyrics.get(songId);
    return lyrics;
  }

   _fetchAudio(SongResponse song) async {
    try {

      // Replace 'YOUR_AUDIO_URI' with your actual audio URI
      var response = await _dio.get<List<int>>(
        song.downloadUrl!.last.link,
        options: Options(responseType: ResponseType.bytes),
      );

      if (response.statusCode == 200) {
        _audioBytes = Uint8List.fromList(response.data!);
        if (_audioBytes != null) {
          String filePath = '${song.name}.mp3';
          String tempPath = (await getTemporaryDirectory()).path;
          String audioFilePath = '$tempPath/$filePath';

          await File(audioFilePath).writeAsBytes(_audioBytes!);

          // Share the audio using the share package
          Share.shareFiles(
            [audioFilePath], // Provide a list of file paths to share
            mimeTypes: ['audio/mpeg'], // Specify the MIME type of the audio file
            text: 'Check out this awesome audio!', // Optional text message
            subject: 'Audio Sharing', // Optional subject for email
          );
        } else {
          print('Audio not available for sharing.');
        }
      } else {
        // Handle error
        print('Failed to fetch audio. Status code: ${response.statusCode}');
      }
    } catch (error) {
      // Handle Dio errors
      print('Dio error: $error');
    }
  }

  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Center(
              child: CustomCard(
                size: 250,
                leading: Image(
                  image: NetworkImage(widget.song.image!.last.link),
                ),
                title: TextTitle(text: widget.song.name.toString(), overflow: TextOverflow.ellipsis,),
                subTitle: SubTitle(text: widget.song.primaryArtists,overflow: TextOverflow.ellipsis),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                    onPressed: () {
                      lyricPopup(context,widget.song.id );
                    },
                    icon: Icon(
                      Icons.lyrics,
                      size: 25,
                    )),
                IconButton(
                  onPressed: ()  async {

                    try{
                      print("tapped");
                      await _fetchAudio(widget.song);
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
                    controller.play(widget.song.downloadUrl!.last.link);
                  },
                  icon: Icon(
                    Icons.play_arrow_rounded,
                    size: 40,
                  ),
                ),
              ],
            ).paddingOnly(right: 20),

          ],
        ),
      ),
    );
  }
}




