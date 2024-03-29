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
    apiKey: 'AIzaSyC_IjDG-Wc4eQTagldol_BtM3YQiSFIeNo',
    appId: '1:596144554897:web:f63172fe61b66eaa275030',
    messagingSenderId: '596144554897',
    projectId: 'flutter-messenger-app-16369',
    authDomain: 'flutter-messenger-app-16369.firebaseapp.com',
    storageBucket: 'flutter-messenger-app-16369.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBqtQbhamqL9alqhiBug480gjPsm_Dsa2s',
    appId: '1:596144554897:android:1efcd3348eea1d47275030',
    messagingSenderId: '596144554897',
    projectId: 'flutter-messenger-app-16369',
    storageBucket: 'flutter-messenger-app-16369.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAbYp6j_V9E22uIk0Utn0X1Gav6kGU9cCg',
    appId: '1:596144554897:ios:6986793815ff6b5a275030',
    messagingSenderId: '596144554897',
    projectId: 'flutter-messenger-app-16369',
    storageBucket: 'flutter-messenger-app-16369.appspot.com',
    iosBundleId: 'com.example.flutterMessengerApp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAbYp6j_V9E22uIk0Utn0X1Gav6kGU9cCg',
    appId: '1:596144554897:ios:38120d1d5881cf20275030',
    messagingSenderId: '596144554897',
    projectId: 'flutter-messenger-app-16369',
    storageBucket: 'flutter-messenger-app-16369.appspot.com',
    iosBundleId: 'com.example.flutterMessengerApp.RunnerTests',
  );
}
