import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:html_unescape/html_unescape.dart';
import 'package:SignumBeat/jiosaavn/models/song.dart';
import 'package:SignumBeat/widgets/PopupScreens/songDetailPopup.dart';

class SongTile extends StatelessWidget {
  final SongResponse song;
  Function() onTap;
    SongTile({
     super.key,
     required this.song,
     required this.onTap
   });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 400,
      child: ListTile(
        onTap: onTap,
        leading: Image(
            image: NetworkImage(
                song.image!.first.link)),
        title: Text(
          HtmlUnescape()
              .convert(song.name.toString()),
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Text(song.primaryArtists,
            overflow: TextOverflow.ellipsis),
        trailing: Wrap(
          children: [
            IconButton(
              onPressed: (){},
              icon: Icon(CupertinoIcons.arrow_down_to_line)
            ),
            IconButton(
              onPressed: (){
                songDetailPopup(context,song );
              },
              icon: Icon(Icons.more_vert)
            ),
            // Image.asset('assets/icons/icons8_audio_wave.gif')
          ],
        ),
      ).paddingZero,
    );
  }
}
