import 'package:on_audio_query/on_audio_query.dart';

class AudioQuery{
  final audioQuery = OnAudioQuery();

  var list;

  Future<List<PlaylistModel>> getPlayList() async {
    try {
     list= await audioQuery.queryPlaylists();
     return list;
    }catch (e) {
      print("failed to fetch playlist : $e}");
      return list;
    }

  }
  createToPlaylist(String name){
    try {
      audioQuery.createPlaylist(name);
    }catch (e) {
      print("failed to create playlist : $e}");
    }
  }
  deletePlaylist(int playlistId){
    try {
      audioQuery.removePlaylist(playlistId);
    } catch (e) {
      print("failed to remove playlist : $e}");
    }
  }
  addToPlaylist(int playlistId,int audioId){
    try {
      audioQuery.addToPlaylist(playlistId, audioId);
      print("song add to playlist $playlistId");
    }catch (e) {
      print("failed to adding song to the playlist: $e");
    }
  }
}