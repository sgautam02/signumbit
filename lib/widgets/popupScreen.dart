import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:SignumBeat/querys/AudioQuery.dart';

import 'package:xen_popup_card/xen_popup_card.dart';

class PopupScreen{

  static final audioQuery = AudioQuery();

  static addToPlaylist(BuildContext context, int sid) {
    Navigator.of(context).pop();
    showGeneralDialog(
      context: context,
      pageBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) {
        return Center(
          child: Container(
            width: double.maxFinite, // Set your desired width
            height: 500, // Set your desired height
            child: XenPopupCard(
              body: FutureBuilder<List<PlaylistModel>>(
                future: audioQuery.audioQuery.queryPlaylists(),
                builder: (BuildContext context, AsyncSnapshot<List<PlaylistModel>> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else if (!snapshot.hasData || snapshot.data == null) {
                    return Text('No data available');
                  }

                  var list = snapshot.data!;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Add to playlist")
                        ],
                      ),
                      ListTile(
                        title: Text("new"),
                        onTap: ()=>createPlaylistPopup(context),
                      ),
                      Expanded(
                        child: ListView.builder(
                        itemCount: list.length,
                          itemBuilder: (c, i) {
                            return ListTile(
                              title: Text(list[i].playlist),
                              onTap:()=> audioQuery.addToPlaylist(list[i].id, sid),
                            );
                          },
                        ),
                      )
                    ],
                  );
                },
              ),
            ),
          ),
        );
      },
      transitionBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child) {
        const begin = Offset(0, 1);
        const end = Offset(0, 0.3);
        const curve = Curves.easeInOut;
        var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        var offsetAnimation = animation.drive(tween);
        return SlideTransition(
          position: offsetAnimation,
          child: child,
        );
      },
      transitionDuration: const Duration(milliseconds: 300),
      barrierLabel: 'Dismiss',
      barrierDismissible: true,
    );
  }



  static menuPopup(BuildContext context,SongModel song) {
    showGeneralDialog(
      context: context,
      pageBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) => Center(
        child: Container(
          width: double.maxFinite, // Set your desired width
          height: 500, // Set your desired height
          child: XenPopupCard(
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children:[
                Text(song.title),
                TextButton(
                    onPressed: () {
                      // addToPlaylist(context,"Play later");
                      },
                    child: Text("Play later")
                ),
                TextButton(
                    onPressed: () {
                      addToPlaylist(context,song.id);
                      },
                    child: Text("Add to playlist")
                ),
                TextButton(
                    onPressed: () {
                      // popcard(context,"Delete");
                      },
                    child: Text("Delete")
                ),
                TextButton(
                    onPressed: () {
                      // popcard(context,"Share");
                      },
                    child: Text("Share")
                ),
              ]
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


  static createPlaylistPopup(BuildContext context) {
    TextEditingController playlistNameController = TextEditingController();

    showGeneralDialog(
      context: context,
      pageBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) {
        double keyboardHeight = MediaQuery.of(context).viewInsets.bottom;

        return SingleChildScrollView(
          child: Container(
            width: double.maxFinite,
            height: 500,
            margin: EdgeInsets.only(bottom: keyboardHeight),
            child: XenPopupCard(
              body: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text("Playlist name"),
                  TextFormField(
                    controller: playlistNameController,
                    decoration: InputDecoration(
                      hintText: 'Enter playlist name',
                    ),
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      String playlistName = playlistNameController.text;
                      if (playlistName.isNotEmpty) {

                         audioQuery.createToPlaylist(playlistName);
                         Navigator.of(context).pop();
                      } else {
                        // Show an error message or handle empty playlist name
                      }
                    },
                    child: Text("Create Playlist"),
                  ),
                ],
              ),
            ),
          ),
        );
      },
      transitionBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child) {
        const begin = Offset(0, 1);
        const end = Offset(0, 0.3);
        const curve = Curves.easeInOut;
        var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        var offsetAnimation = animation.drive(tween);
        return SlideTransition(
          position: offsetAnimation,
          child: child,
        );
      },
      transitionDuration: const Duration(milliseconds: 300),
      barrierLabel: 'Dismiss',
      barrierDismissible: true,
    );
  }



// Example function to create a playlist (replace with your implementation)
  void createPlaylist(String playlistName) {
    print('Creating playlist: $playlistName');
    // Add your logic to create the playlist
  }

}