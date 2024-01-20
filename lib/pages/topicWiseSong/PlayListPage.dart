import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';

import '../../querys/AudioQuery.dart';

class PlayListPage extends StatelessWidget {
   PlayListPage({super.key});
  var audioQuery = AudioQuery();
  var playslist;

   Future<List<PlaylistModel>> getPlayList() async {
    playslist= await audioQuery.audioQuery.queryPlaylists();
    return playslist;
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar:AppBar(),
      body:Column(
        children: [
          TextButton(onPressed:()=> audioQuery.createToPlaylist("newPlaylist"), child: Text("Create new Play list")),
          Expanded(
            child: FutureBuilder(
              future: getPlayList(),
              builder: (BuildContext context, AsyncSnapshot<List<PlaylistModel>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator(); // or any loading indicator
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else if (!snapshot.hasData || snapshot.data == null) {
                  return Text('No data available'); // Handle the case where data is null
                }

                var list = snapshot.data!;
                return ListView.builder(
                    itemCount: list.length,
                    itemBuilder: (c, i) {
                      return ListTile(
                        title: Text(list[i].playlist),
                        subtitle: Text(list[i].numOfSongs.toString()),
                        trailing: IconButton(
                          onPressed: ()=>audioQuery.deletePlaylist(list[i].id), 
                          icon: Icon(Icons.delete_forever_rounded),
                        ),
                      );
                    }
                );
              },
            )

          )
        ],
      )
    );
  }
}
