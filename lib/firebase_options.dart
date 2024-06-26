// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
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
        return windows;
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
    apiKey: 'AIzaSyBDFfukUZGcN2bdFskXs1WWWWvr5_4ChUU',
    appId: '1:569793758862:web:07971f23518d35b5c4ebdf',
    messagingSenderId: '569793758862',
    projectId: 'cakedayreminder',
    authDomain: 'cakedayreminder.firebaseapp.com',
    databaseURL: 'https://cakedayreminder-default-rtdb.europe-west1.firebasedatabase.app',
    storageBucket: 'cakedayreminder.appspot.com',
    measurementId: 'G-ZZQ75VCHS6',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBK3in2zsSo0P2aP8foPlByOStmSNry6ZU',
    appId: '1:569793758862:android:95db894971a011cfc4ebdf',
    messagingSenderId: '569793758862',
    projectId: 'cakedayreminder',
    databaseURL: 'https://cakedayreminder-default-rtdb.europe-west1.firebasedatabase.app',
    storageBucket: 'cakedayreminder.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAVmPCxIwNFwIu2ihjTDZwwuSRwdQt2a0E',
    appId: '1:569793758862:ios:3e437f06cb75ba22c4ebdf',
    messagingSenderId: '569793758862',
    projectId: 'cakedayreminder',
    databaseURL: 'https://cakedayreminder-default-rtdb.europe-west1.firebasedatabase.app',
    storageBucket: 'cakedayreminder.appspot.com',
    iosClientId: '569793758862-hdun6vhrndn4cpkkmao1ge61amdiu2ad.apps.googleusercontent.com',
    iosBundleId: 'com.oleksandrkavun.cakedayreminder',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAVmPCxIwNFwIu2ihjTDZwwuSRwdQt2a0E',
    appId: '1:569793758862:ios:c63b1441281761acc4ebdf',
    messagingSenderId: '569793758862',
    projectId: 'cakedayreminder',
    databaseURL: 'https://cakedayreminder-default-rtdb.europe-west1.firebasedatabase.app',
    storageBucket: 'cakedayreminder.appspot.com',
    iosClientId: '569793758862-o9rr0mksm522f1rg1nldt0pjnej9qtmo.apps.googleusercontent.com',
    iosBundleId: 'com.example.cakedayReminder',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyBDFfukUZGcN2bdFskXs1WWWWvr5_4ChUU',
    appId: '1:569793758862:web:320d0d7ce4a8e3a3c4ebdf',
    messagingSenderId: '569793758862',
    projectId: 'cakedayreminder',
    authDomain: 'cakedayreminder.firebaseapp.com',
    databaseURL: 'https://cakedayreminder-default-rtdb.europe-west1.firebasedatabase.app',
    storageBucket: 'cakedayreminder.appspot.com',
    measurementId: 'G-5L1F69T8J6',
  );

}