import 'dart:io';

import 'package:dio/dio.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:music_melody/const/colors.dart';
import 'package:music_melody/const/text_style.dart';
import 'package:path_provider/path_provider.dart';

themePage() {}

class downloadTheme extends StatefulWidget {
  const downloadTheme({super.key});

  @override
  State<downloadTheme> createState() => _downloadThemeState();
}

class _downloadThemeState extends State<downloadTheme> {
  late Future<ListResult> futureFiles;
  Map<int, double> downloadProgress = {};

  @override
  void initState() {
    super.initState();
    initializeFirebase(); // Panggil fungsi untuk menginisialisasi Firebase
    futureFiles = FirebaseStorage.instance.ref('').listAll();
  }

  Future<void> initializeFirebase() async {
    await Firebase.initializeApp();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Text("Theme download",
              style: ourStyle(color: whiteColor, size: 20)),
        ),
        body: Padding(
          padding: const EdgeInsets.all(10.0), // Tambahkan padding di sini
          child: FutureBuilder<ListResult>(
            future: futureFiles,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final files = snapshot.data!.items;
                return ListView.builder(
                  itemCount: files.length,
                  itemBuilder: (context, index) {
                    final file = files[index];
                    double? progress = downloadProgress[index];
                    return Column(
                      children: [
                        ListTile(
                          tileColor: bgColor, // Warna latar belakang merah
                          title: Text(
                            file.name,
                            style: ourStyle(color: whiteColor),
                          ),
                          subtitle: progress != null
                              ? LinearProgressIndicator(
                                  value: progress,
                                  backgroundColor: sliderColor,
                                )
                              : null,
                          trailing: IconButton(
                            icon: Icon(
                              Icons.downloading_outlined,
                              color: sliderColor,
                            ),
                            onPressed: () {
                              downloadFile(index, file);
                            },
                          ),
                        ),
                        Divider(
                          height: 5.0, // Tambahkan jarak di sini
                          color: Colors.transparent, // Warna pemisah transparan
                        ),
                      ],
                    );
                  },
                );
              } else if (snapshot.hasError) {
                return const Center(
                  child: Text("Error"),
                );
              } else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          ),
        ),
      );
  Future downloadFile(int index, Reference ref) async {
    final url = await ref.getDownloadURL();
    final tempDir = await getTemporaryDirectory();
    final folderPath = '${tempDir.path}/MyDownloadedFiles'; // Nama folder
    final path = '$folderPath/${ref.name}';

    // Membuat folder jika belum ada
    await Directory(folderPath).create(recursive: true);

    await Dio().download(url, path, onReceiveProgress: (received, total) {
      double progress = (received / total);
      setState(() {
        downloadProgress[index] = progress;
      });
    });
    if (url.contains('.jpg') || url.contains('.png')) {
      await GallerySaver.saveImage(path,
          albumName: "MUSIC_MELODY/music_Picture/");
    } else if (url.contains('.mp4')) {
      await GallerySaver.saveVideo(path,
          albumName: "MUSIC_MELODY/music_Picture/");
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: whiteColor,
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
        content: Text(
          'Downloaded ${ref.name}',
          style: ourStyle(
            color: bgDarkColor,
          ),
        ),
      ),
    );
  }
}
