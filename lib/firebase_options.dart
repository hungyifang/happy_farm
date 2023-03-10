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
    apiKey: 'AIzaSyDQILL8xIDhsmGn_qZd06gv4u8xHjfFy3k',
    appId: '1:777201189122:web:c34a9ddaf0f7dd8d22c21b',
    messagingSenderId: '777201189122',
    projectId: 'happyfarm-b8078',
    authDomain: 'happyfarm-b8078.firebaseapp.com',
    storageBucket: 'happyfarm-b8078.appspot.com',
    measurementId: 'G-D007RBBHXG',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBF0v4HmsJvGPYLn-thS9V1kl5eWu1s2UA',
    appId: '1:777201189122:android:0d77d796d704714122c21b',
    messagingSenderId: '777201189122',
    projectId: 'happyfarm-b8078',
    storageBucket: 'happyfarm-b8078.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDGyGIZMRuEQPxXIAlVwPhskOIUrYtRmEU',
    appId: '1:777201189122:ios:3863cb2ecdb4c65b22c21b',
    messagingSenderId: '777201189122',
    projectId: 'happyfarm-b8078',
    storageBucket: 'happyfarm-b8078.appspot.com',
    androidClientId: '777201189122-9mg45skj19qv928qq9s4dd1h3blkdkov.apps.googleusercontent.com',
    iosClientId: '777201189122-0dhdkskbrn6sjtnpuv09bcgktdafh9i4.apps.googleusercontent.com',
    iosBundleId: 'com.example.happyFarm',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDGyGIZMRuEQPxXIAlVwPhskOIUrYtRmEU',
    appId: '1:777201189122:ios:3863cb2ecdb4c65b22c21b',
    messagingSenderId: '777201189122',
    projectId: 'happyfarm-b8078',
    storageBucket: 'happyfarm-b8078.appspot.com',
    androidClientId: '777201189122-9mg45skj19qv928qq9s4dd1h3blkdkov.apps.googleusercontent.com',
    iosClientId: '777201189122-0dhdkskbrn6sjtnpuv09bcgktdafh9i4.apps.googleusercontent.com',
    iosBundleId: 'com.example.happyFarm',
  );
}
