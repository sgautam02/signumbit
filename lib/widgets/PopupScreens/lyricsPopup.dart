 import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:xen_popup_card/xen_popup_card.dart';

import '../../jiosaavn/jiosaavn.dart';
import '../../jiosaavn/models/lyrics.dart';
 Future<LyricsResponse> getLyrics(songId) async {
   final jio = JioSaavnClient();
   var lyrics = await jio.lyrics.get(songId);
   return lyrics;
 }
lyricPopup(BuildContext context,String songId) async {
  showGeneralDialog(
    context: context,
    pageBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) => Center(

      child: Container(
        width: double.maxFinite, // Set your desired width
        height: 500, // Set your desired height
        child: XenPopupCard(
          cardBgColor: Theme.of(context).primaryColor,
          body: FutureBuilder(
            future: getLyrics(songId),
        builder: (BuildContext c, AsyncSnapshot<LyricsResponse> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError || snapshot.data == null) {
            return Center(child: Text("Lyrics not found for this song"));
          } else {
            var lyrics = snapshot.data!.lyrics!.split('\n');
            return SingleChildScrollView(
              child: Column(
                children: List.generate(
                  lyrics.length,
                      (index) => Text(lyrics[index]),
                ),
              ),
            );
          }
        },
      ),

    ),
      ),
    ),
    transitionBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child) {
      const begin = Offset(0,1);
      const end = Offset(0,0.3);
      const curve = Curves.easeInOut;
      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
      var offsetAnimation = animation.drive(tween);
      return SlideTransition(
        position: offsetAnimation,
        child: child,
      );
    },
    transitionDuration: const Duration(milliseconds: 300),
    barrierLabel: 'Dismiss', // Provide a non-null value for barrierLabel
    barrierDismissible: true,
  );
}