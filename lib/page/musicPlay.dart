// ignore_for_file: deprecated_member_use, sized_box_for_whitespace, prefer_const_constructors, no_leading_underscores_for_local_identifiers, file_names, avoid_print, sort_child_properties_last
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:music_melody/const/colors.dart';
import 'package:music_melody/const/text_style.dart';
import 'package:music_melody/controller/player_control.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:video_player/video_player.dart';

class ThemeEdit extends StatefulWidget {
  final List<SongModel> data;
  const ThemeEdit({Key? key, required this.data}) : super(key: key);
  @override
  State<ThemeEdit> createState() => _ThemeEditState();
}

class _ThemeEditState extends State<ThemeEdit> {
  late VideoPlayerController? _controller;
  var controller = Get.find<PlayerController>();

  String? videoPath;
  File? image;
  String downColor = "Dark";
  String profileColor = "Yellow";
  List<RxString> items = [
    "Dark".obs,
    "White".obs,
    "Yellow".obs,
    "Transparent".obs,
  ];
  List<RxString> profile = [
    "Yellow".obs,
    "Transparent".obs,
  ];

  @override
  void initState() {
    super.initState();
    _permissionStorage();
  }

  _permissionStorage() async {
    var status = await Permission.storage.status;
    if (!status.isGranted) {
      var result = await Permission.storage.request();
      if (result.isDenied) {
        return;
      }
    }
  }

  _intialVideoPlayer(File path) async {
    try {
      _controller = VideoPlayerController.file(path);
      await _controller!.setVolume(0.0);
      await _controller!.initialize().then((_) {
        setState(() {
          videoPath = path.path;
          image = null;
        });
      });
      _controller!.play();
      _controller!.setLooping(true);
    } catch (error) {
      print('Error initializing video controller: $error');
    }
  }

  @override
  void dispose() {
    _controller!.dispose();
    super.dispose();
  }

  Future<void> pickVideo() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.video,
    );
    if (result != null) {
      List<PlatformFile> files = result.files;
      PlatformFile file = files.first;
      File path = File(file.path!);
      _intialVideoPlayer(path);
    } else {
      print("Video selection canceled");
    }
  }

  Future<void> getImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? imagePicker =
        await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      image = File(imagePicker!.path);
      videoPath = null; // Reset video when image is selected
    });
  }

  String? selectedValue;
  String? selectedProfile;

  void _showSortBottomSheet(BuildContext context) {
    showModalBottomSheet(
      backgroundColor: bgDarkColor,
      context: context,
      builder: (BuildContext context) {
        return SizedBox(
          height: 400,
          child: ListView(
            padding: EdgeInsets.all(10),
            children: [
              Container(
                width: 200,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: bgColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(0),
                    ),
                  ),
                  onPressed: () async {
                    await getImage();
                  },
                  child: Text(
                    "Edit Image",
                    style: ourStyle(color: whiteColor),
                  ),
                ),
              ),
              Container(
                width: 200,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: bgColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(0),
                    ),
                  ),
                  onPressed: () async {
                    await pickVideo();
                  },
                  child: Text(
                    "Edit Video",
                    style: ourStyle(color: whiteColor),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 20),
                width: 200,
                decoration: BoxDecoration(color: bgColor),
                child: DropdownButton(
                  isExpanded: true,
                  value: selectedValue,
                  onChanged: (value) {
                    setState(() {
                      selectedValue = value;
                      downColor = value.toString();
                    });
                  },
                  items: items
                      .map<DropdownMenuItem<String?>>((e) => DropdownMenuItem(
                            child: Text(e.value),
                            value: e.value,
                          ))
                      .toList(),
                  style: ourStyle(color: whiteColor),
                  dropdownColor: bgColor,
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 20),
                width: 200,
                decoration: BoxDecoration(color: bgColor),
                child: DropdownButton(
                  isExpanded: true,
                  value: selectedProfile,
                  onChanged: (value) {
                    setState(() {
                      selectedProfile = value;
                      profileColor = value.toString();
                    });
                  },
                  items: profile
                      .map<DropdownMenuItem<String?>>((e) => DropdownMenuItem(
                            child: Text(e.value),
                            value: e.value,
                          ))
                      .toList(),
                  style: ourStyle(color: whiteColor),
                  dropdownColor: bgColor,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  int p = 0;
  @override
  Widget build(BuildContext context) {
    var controller = Get.find<PlayerController>();

    List<SongModel> data = widget.data;
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: downColor == "Dark"
            ? bgDarkColor
            : downColor == "White"
                ? whiteColor
                : downColor == "Yellow"
                    ? sliderColor
                    : Colors.transparent,
        actions: [
          IconButton(
            onPressed: () {
              _showSortBottomSheet(context);
            },
            icon: Icon(
              Icons.edit,
              color: downColor == "White" ? bgDarkColor : whiteColor,
            ),
          )
        ],
      ),
      body: Obx(
        () => Stack(
          fit: StackFit.expand,
          children: [
            if (image != null)
              Image.file(image!, fit: BoxFit.cover)
            else if (videoPath != null)
              _controller != null ? VideoPlayer(_controller!) : Container(),
            Column(
              children: [
                Obx(
                  () => Expanded(
                    child: Container(
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      height: 300,
                      width: 250,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: profileColor == "Yellow"
                            ? sliderColor
                            : Colors.transparent,
                      ),
                      child: QueryArtworkWidget(
                          id: data[controller.playIndex.value].id,
                          type: ArtworkType.AUDIO,
                          artworkHeight: double.infinity,
                          artworkWidth: double.infinity,
                          nullArtworkWidget: const Icon(
                            Icons.music_note,
                            size: 48,
                            color: bgDarkColor,
                          )),
                    ),
                  ),
                ),
                SizedBox(height: 12),
                Expanded(
                  child: Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: downColor == "Dark"
                          ? bgDarkColor
                          : downColor == "White"
                              ? whiteColor
                              : downColor == "Yellow"
                                  ? sliderColor
                                  : Colors.transparent,
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(10)),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          SizedBox(height: 28),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              data[controller.playIndex.value].displayNameWOExt,
                              style: ourStyle(
                                color: downColor == "White"
                                    ? bgDarkColor
                                    : whiteColor,
                                size: 26,
                              ),
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          ),
                          SizedBox(height: 12),
                          Text(
                            data[controller.playIndex.value].artist.toString(),
                            style: ourStyle(
                              color: downColor == "White"
                                  ? bgDarkColor
                                  : whiteColor,
                              size: 20,
                            ),
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                          SizedBox(height: 12),
                          Obx(
                            () => Row(
                              children: [
                                Text(
                                  controller.position.value,
                                  style: ourStyle(
                                    color: downColor == "White"
                                        ? bgDarkColor
                                        : whiteColor,
                                  ),
                                ),
                                Expanded(
                                  child: Slider(
                                    thumbColor: downColor == "Yellow"
                                        ? bgDarkColor
                                        : whiteColor,
                                    activeColor: downColor == "Yellow"
                                        ? bgDarkColor
                                        : whiteColor,
                                    min: Duration(seconds: 0)
                                        .inSeconds
                                        .toDouble(),
                                    max: controller.max.value,
                                    value: controller.value.value,
                                    onChanged: (newValue) {
                                      controller
                                          .changeDuration(newValue.toInt());
                                      newValue = newValue;
                                    },
                                  ),
                                ),
                                Text(
                                  controller.duration.value,
                                  style: ourStyle(
                                    color: downColor == "White"
                                        ? bgDarkColor
                                        : whiteColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              IconButton(
                                onPressed: () {
                                  controller.playSong(
                                      data[controller.playIndex.value - 1].uri,
                                      controller.playIndex.value - 1);
                                },
                                icon: Icon(
                                  Icons.skip_previous_rounded,
                                  size: 40,
                                  color: downColor == "Yellow"
                                      ? bgDarkColor
                                      : whiteColor,
                                ),
                              ),
                              Obx(
                                () => CircleAvatar(
                                  radius: 35,
                                  backgroundColor: bgDarkColor,
                                  child: Transform.scale(
                                    scale: 2.5,
                                    child: IconButton(
                                      onPressed: () {
                                        if (controller.isPlaying.value) {
                                          controller.audioPlayer.pause();
                                          controller.isPlaying(false);
                                        } else {
                                          controller.audioPlayer.pause();
                                          controller.isPlaying(true);
                                        }
                                      },
                                      icon: controller.isPlaying.value
                                          ? Icon(
                                              Icons.pause_circle_rounded,
                                              color: whiteColor,
                                            )
                                          : Icon(
                                              Icons.play_arrow_rounded,
                                              color: whiteColor,
                                            ),
                                    ),
                                  ),
                                ),
                              ),
                              IconButton(
                                onPressed: () {
                                  controller.playSong(
                                      data[controller.playIndex.value + 1].uri,
                                      controller.playIndex.value + 1);
                                },
                                icon: Icon(
                                  Icons.skip_next_rounded,
                                  size: 40,
                                  color: downColor == "Yellow"
                                      ? bgDarkColor
                                      : whiteColor,
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
