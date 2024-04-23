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
    apiKey: 'AIzaSyCTqctu0RV7orqJdFY4_IzoCgd2pKZvOS8',
    appId: '1:626969402580:web:67709b5c7820848cabef41',
    messagingSenderId: '626969402580',
    projectId: 'fooddeliveryapp-dd504',
    authDomain: 'fooddeliveryapp-dd504.firebaseapp.com',
    storageBucket: 'fooddeliveryapp-dd504.appspot.com',
    measurementId: 'G-XZGMKQL07G',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyA8zKSLk1oJuJIJ2w26QdC8nAzvTxHe1Ac',
    appId: '1:626969402580:android:6a152817f793bef0abef41',
    messagingSenderId: '626969402580',
    projectId: 'fooddeliveryapp-dd504',
    storageBucket: 'fooddeliveryapp-dd504.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDX4aTe10FGrESUZx1b1wZlQ337cyXY_xA',
    appId: '1:626969402580:ios:4a40eeb689f49b64abef41',
    messagingSenderId: '626969402580',
    projectId: 'fooddeliveryapp-dd504',
    storageBucket: 'fooddeliveryapp-dd504.appspot.com',
    iosBundleId: 'com.example.adminWebPortal',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDX4aTe10FGrESUZx1b1wZlQ337cyXY_xA',
    appId: '1:626969402580:ios:4a40eeb689f49b64abef41',
    messagingSenderId: '626969402580',
    projectId: 'fooddeliveryapp-dd504',
    storageBucket: 'fooddeliveryapp-dd504.appspot.com',
    iosBundleId: 'com.example.adminWebPortal',
  );
}
