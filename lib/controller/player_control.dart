import 'dart:async';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:video_player/video_player.dart';

class PlaylistController extends GetxController {
  final PlayerController playerController = Get.find();
  final List<PlayerController> playlist = [Get.find()];
  final audioQuery = OnAudioQuery();

  void addToPlaylist(PlayerController music) {
    playlist.add(music);
  }

  void removeFromPlaylist(int index) {
    playlist.removeAt(index);
  }

  void clearPlaylist() {
    playlist.clear();
  }
}

void main() {
  final PlaylistController playlistController = PlaylistController();

  playlistController.removeFromPlaylist(1);

  playlistController.clearPlaylist();
}

class videoPlayer{
  videoPlayer(VideoPlayerController controller);
 

}

class PlayerController extends GetxController {
  final audioQuery = ();
  final RxList<SongModel> songs = <SongModel>[].obs;
  final audioPlayer = AudioPlayer();

  var playIndex = 0.obs;
  var isPlaying = false.obs;
  var duration = ''.obs;
  var position = ''.obs;
  var max = 0.0.obs;
  var value = 0.0.obs;

  @override
  void onInit() {
    super.onInit();
    checkPermissions();
  }

  void updatePosition() {
    audioPlayer.durationStream.listen((d) {
      duration.value = d.toString().split(".")[0];
      max.value = d!.inSeconds.toDouble();
    });
    audioPlayer.positionStream.listen((p) {
      position.value = p.toString().split(".")[0];
      value.value = p.inSeconds.toDouble();
    });
  }

  changeDuration(seconds) {
    var duration = Duration(seconds: seconds);
    audioPlayer.seek(duration);
  }

  void playSong(String? uri, int index) {
    playIndex.value = index;
    try {
      audioPlayer.setAudioSource(AudioSource.uri(Uri.parse(uri!)));
      audioPlayer.play();
      isPlaying.value =
          true; // Fix: Use `.value` to update GetX observable variable
      updatePosition();
    } on Exception catch (e) {
      print(e.toString());
    }
  }

  Future<void> checkPermissions() async {
    var status = await Permission.storage.request();
    if (status.isGranted) {
    } else {
      checkPermissions();
    }
  }
}
