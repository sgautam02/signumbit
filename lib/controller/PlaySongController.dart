import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:on_audio_query/on_audio_query.dart';

import '../jiosaavn/models/song.dart';
import '../utils/UniVar.dart';
import '../utils/permission.dart';

class PlaySongController extends GetxController {
  final audioQuery = OnAudioQuery();
  final audioPlayer = AudioPlayer();
  var playIndex = 0.obs;
  var isPlaying = false.obs;
  var duration = ''.obs;
  var position = ''.obs;
  var max = 0.0.obs;
  var value = 0.0.obs;
  var playerProcessingState = ''.obs;
  var playingModSong = Rx<dynamic>(null);

  @override
  Future<void> onInit() async {
    var permissions = checkPermission();
    audioPlayer.playerStateStream.listen((playerState) {
      playerState.processingState.name == 'loading'
          ? playerProcessingState.value = 'loading'
          : playerProcessingState.value = 'idle';
      isPlaying.value = playerState.playing;
      if (playerState.processingState == ProcessingState.completed) {
        playNextSong();
      }
    });
    super.onInit();
  }

  playSong(var song, index) {
    playIndex.value = index;
    try {
      // Update playingSong using .value
      if (song is SongModel) {
        playingModSong.value = song;
        audioPlayer.setAudioSource(AudioSource.uri(Uri.parse(song.uri!)));
      } else if (song is SongResponse) {
        playingModSong.value = song;
        audioPlayer.setAudioSource(
            AudioSource.uri(Uri.parse(song.downloadUrl!.last.link)));
      }
      audioPlayer.play();
      isPlaying(true);
      updatePosition();
    } catch (e) {
      print(e);
    }
  }

  playSongs(String uri, index) {
    playIndex.value = index;
    try {
      audioPlayer.setAudioSource(AudioSource.uri(Uri.parse(uri)));
      audioPlayer.play();
      isPlaying(true);
      updatePosition();
    } catch (e) {
      print(e);
    }
  }

  play(String url) {
    try {
      audioPlayer.setAudioSource(AudioSource.uri(Uri.parse(url.toString())));
      audioPlayer.play();
      isPlaying(true);
      updatePosition();
    } catch (e) {
      print(e);
    }
  }

  playNextSong() {
    // Check if there's a next song to play
    if (playIndex.value < UniVar.data!.length - 1) {
      var nextIndex = playIndex.value + 1;
      var nextSong = UniVar.data?[nextIndex];
      playSong(nextSong, nextIndex);
    } else {
      // If it's the last song, stop playback or handle as needed
      audioPlayer.stop();
      isPlaying(false);
    }
  }

  updatePosition() {
    audioPlayer.durationStream.listen((d) {
      duration.value = d.toString().split(".")[0];
      max.value = d!.inSeconds.toDouble();
    });
    audioPlayer.positionStream.listen((p) {
      position.value = p.toString().split(".")[0];
      value.value = p.inSeconds.toDouble();
    });
  }

  changeDurationToSecond(second) {
    var duration = Duration(seconds: second);
    audioPlayer.seek(duration);
  }
}
