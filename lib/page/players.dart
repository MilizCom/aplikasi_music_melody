import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:music_melody/const/colors.dart';
import 'package:music_melody/const/text_style.dart';
import 'package:music_melody/controller/player_control.dart';
import 'package:music_melody/page/musicPlay.dart';
import 'package:on_audio_query/on_audio_query.dart';

class MusicMelodyHomePage extends StatelessWidget {
  final PlayerController controller = Get.put(PlayerController());
  final PlaylistController playlistController = PlaylistController();
  bool modePlayList = true;

  void _showSortBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SizedBox(
          height: 400,
          child: Center(
            child: ElevatedButton(
              child: Text("pop"),
              onPressed: () {},
            ),
          ),
        );
      },
    );
  }

  Widget _buildSongList(List<SongModel> songs) {
    return ListView.builder(
      physics: BouncingScrollPhysics(),
      itemCount: songs.length,
      itemBuilder: (BuildContext context, int index) {
        return Container(
          margin: EdgeInsets.only(bottom: 4),
          child: Obx(
            () => ListTile(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              tileColor: bgColor,
              title: Text(
                songs[index].displayNameWOExt,
                style: ourStyle(color: whiteColor, size: 15),
              ),
              subtitle: Text(
                "${songs[index].artist}",
                style: ourStyle(size: 12),
              ),
              leading: QueryArtworkWidget(
                id: songs[index].id,
                type: ArtworkType.AUDIO,
                nullArtworkWidget: Icon(
                  Icons.music_note,
                  color: whiteColor,
                  size: 12,
                ),
              ),
              trailing:
                  controller.playIndex == index && controller.isPlaying.value
                      ? Icon(
                          Icons.play_arrow,
                          color: whiteColor,
                          size: 32,
                        )
                      : null,
              onTap: () {
                controller.playSong(songs[index].uri, index);
                Get.to(() => ThemeEdit(data: songs));
              },
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgDarkColor,
      appBar: AppBar(
        backgroundColor: bgDarkColor,
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.search,
              color: whiteColor,
            ),
          )
        ],
        leading: IconButton(
          onPressed: () {
            modePlayList = true;
            _showSortBottomSheet(context);
          },
          icon: Icon(
            Icons.sort_rounded,
            color: whiteColor,
          ),
        ),
        title: Text(
          "Music Melody",
          style: ourStyle(color: whiteColor, size: 14),
        ),
      ),
      body: FutureBuilder<List<SongModel>>(
        future: OnAudioQuery().querySongs(
          ignoreCase: true,
          orderType: OrderType.ASC_OR_SMALLER,
          sortType: null,
          uriType: UriType.EXTERNAL,
        ),
        builder: (BuildContext context, snapshot) {
          if (snapshot.data == null) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: _buildSongList(snapshot.data!),
            );
          }
        },
      ),
    );
  }
}
