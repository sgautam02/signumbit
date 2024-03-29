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
    apiKey: 'AIzaSyCL4zJZIo10W4b9CjBNrQ2glW5ozkeZLMo',
    appId: '1:158300634528:web:b3e21ef8a1e01fefd278c5',
    messagingSenderId: '158300634528',
    projectId: 'signumbeat-70f87',
    authDomain: 'signumbeat-70f87.firebaseapp.com',
    storageBucket: 'signumbeat-70f87.appspot.com',
    measurementId: 'G-FHFMW88EE8',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyB3aWrQaN3MfyAIaR9DSq2uwBz9azVuHfE',
    appId: '1:158300634528:android:0c3a8e2d956ec7a5d278c5',
    messagingSenderId: '158300634528',
    projectId: 'signumbeat-70f87',
    storageBucket: 'signumbeat-70f87.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyB8gnnz0XJNh-HYIhGFgWZ65ecT6nPgDDM',
    appId: '1:158300634528:ios:b4d6da64a420c2d5d278c5',
    messagingSenderId: '158300634528',
    projectId: 'signumbeat-70f87',
    storageBucket: 'signumbeat-70f87.appspot.com',
    iosBundleId: 'com.example.signumbit',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyB8gnnz0XJNh-HYIhGFgWZ65ecT6nPgDDM',
    appId: '1:158300634528:ios:efee06395d4046cdd278c5',
    messagingSenderId: '158300634528',
    projectId: 'signumbeat-70f87',
    storageBucket: 'signumbeat-70f87.appspot.com',
    iosBundleId: 'com.example.signumbit.RunnerTests',
  );
}
