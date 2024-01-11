import 'dart:io';

import 'package:dio/dio.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:music_melody/const/colors.dart';
import 'package:music_melody/const/text_style.dart';
import 'package:music_melody/page/players.dart';
import 'package:path_provider/path_provider.dart';

class NavbarBottom extends StatefulWidget {
  const NavbarBottom({Key? key}) : super(key: key);

  @override
  State<NavbarBottom> createState() => _NavbarBottomState();
}

class _NavbarBottomState extends State<NavbarBottom> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    HomePage(),
    downloadTheme(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgDarkColor,
      body: _pages[_selectedIndex],
      bottomNavigationBar: Container(
        height: 70,
        color: whiteColor,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 13.0, vertical: 13),
          child: GNav(
            backgroundColor: whiteColor,
            activeColor: bgDarkColor,
            tabBackgroundColor: sliderColor,
            gap: 20,
            padding: EdgeInsets.all(10),
            tabs: [
              GButton(
                onPressed: () {
                  setState(() {
                    _selectedIndex = 0;
                  });
                },
                icon: Icons.home_filled,
                iconColor: sliderColor,
                text: "Home",
              ),
              GButton(
                onPressed: () {
                  setState(() {
                    _selectedIndex = 1;
                  });
                },
                icon: Icons.apps,
                iconColor: sliderColor,
                text: "Theme",
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Center(child: MusicMelodyHomePage());
  }
}

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
          backgroundColor: bgDarkColor,
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
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                          tileColor: bgColor, // Warna latar belakang merah
                          title: Text(
                            file.name,
                            style: ourStyle(color: whiteColor),
                          ),
                          subtitle: progress != null
                              ? LinearProgressIndicator(
                                  color: whiteColor,
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
                          height: 15.0, // Tambahkan jarak di sini
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
