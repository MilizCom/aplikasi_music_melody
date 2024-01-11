// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyBZFscfxqp93-abgaodgkuV_9D4FRJiFyE',
    appId: '1:938744634393:web:2f6b85b8a5527405cb5e88',
    messagingSenderId: '938744634393',
    projectId: 'newproject-13c59',
    authDomain: 'newproject-13c59.firebaseapp.com',
    storageBucket: 'newproject-13c59.appspot.com',
    measurementId: 'G-XB9QHPV2ZD',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDn-5IZNVoK3cDG5LOzju3tWCmlgI7I-n8',
    appId: '1:938744634393:android:72fa81b9a6de66b1cb5e88',
    messagingSenderId: '938744634393',
    projectId: 'newproject-13c59',
    storageBucket: 'newproject-13c59.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAaamPuTKuKRJ7vvpJCXiIRrvDQHhhYxMk',
    appId: '1:938744634393:ios:3c7819db6e129023cb5e88',
    messagingSenderId: '938744634393',
    projectId: 'newproject-13c59',
    storageBucket: 'newproject-13c59.appspot.com',
    iosBundleId: 'com.example.musicMelody',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAaamPuTKuKRJ7vvpJCXiIRrvDQHhhYxMk',
    appId: '1:938744634393:ios:c556370a0cce8b2acb5e88',
    messagingSenderId: '938744634393',
    projectId: 'newproject-13c59',
    storageBucket: 'newproject-13c59.appspot.com',
    iosBundleId: 'com.example.musicMelody.RunnerTests',
  );
}