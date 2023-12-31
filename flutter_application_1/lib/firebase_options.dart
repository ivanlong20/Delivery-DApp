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
    apiKey: 'AIzaSyBQYPtZf5C91jqIjL_Ym0h-f1wiERp2GJc',
    appId: '1:899453581415:web:4c1686b6c8e40b6d333cc2',
    messagingSenderId: '899453581415',
    projectId: 'project-1bbe4',
    authDomain: 'project-1bbe4.firebaseapp.com',
    storageBucket: 'project-1bbe4.appspot.com',
    measurementId: 'G-VV2KQYQNR3',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCkkaNMUM94719a3TO5oVoSXYI8wqn266E',
    appId: '1:899453581415:android:31e0bfcfc894645a333cc2',
    messagingSenderId: '899453581415',
    projectId: 'project-1bbe4',
    storageBucket: 'project-1bbe4.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCJ9neEq-Ydw_7HeNH4jBrwRw4IoeRRqBE',
    appId: '1:899453581415:ios:59716a7e038e1eab333cc2',
    messagingSenderId: '899453581415',
    projectId: 'project-1bbe4',
    storageBucket: 'project-1bbe4.appspot.com',
    iosClientId: '899453581415-3l80riivn29d53v5u1put3o3p255p2gq.apps.googleusercontent.com',
    iosBundleId: 'com.example.flutterApplication1',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCJ9neEq-Ydw_7HeNH4jBrwRw4IoeRRqBE',
    appId: '1:899453581415:ios:59716a7e038e1eab333cc2',
    messagingSenderId: '899453581415',
    projectId: 'project-1bbe4',
    storageBucket: 'project-1bbe4.appspot.com',
    iosClientId: '899453581415-3l80riivn29d53v5u1put3o3p255p2gq.apps.googleusercontent.com',
    iosBundleId: 'com.example.flutterApplication1',
  );
}
