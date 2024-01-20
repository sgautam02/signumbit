import 'package:get/get.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:SignumBeat/jiosaavn/models/song.dart';

class UniVar extends GetxController {
  static List<SongModel> searchSong=[];
  static List<dynamic> data=[];
  static List<dynamic> recentData = [].obs;
  static List<SongResponse> playerQueue=[];
  static List<dynamic> favouriteSong=[];

  static void addRecentSong(SongModel song) {
    if (recentData.any((recentSong) => recentSong == song)) {
      return;
    }
    if (recentData.length > 30) {
      recentData.removeLast(); // Remove the oldest item if the list exceeds the maximum size
    }else {
      recentData.insert(0, song);
    }
  }
}
