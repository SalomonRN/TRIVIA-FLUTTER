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
    apiKey: 'AIzaSyBlbxU6FbCC_6TnXamrHEmwQuCRt5gGbK4',
    appId: '1:739793864137:web:a4f9a683aab3064f359418',
    messagingSenderId: '739793864137',
    projectId: 'trivia-62cc9',
    authDomain: 'trivia-62cc9.firebaseapp.com',
    databaseURL: 'https://trivia-62cc9-default-rtdb.firebaseio.com',
    storageBucket: 'trivia-62cc9.appspot.com',
    measurementId: 'G-7WMJDNTDE7',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBjxlPf3lM4QsSPPJMrIO02pDH0UP6K1mY',
    appId: '1:739793864137:android:bb42cbe43a9cabb3359418',
    messagingSenderId: '739793864137',
    projectId: 'trivia-62cc9',
    databaseURL: 'https://trivia-62cc9-default-rtdb.firebaseio.com',
    storageBucket: 'trivia-62cc9.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyC0SzZIzYypJiNRe_PjS10YRoFmA7oWFFs',
    appId: '1:739793864137:ios:d88ae347a7e8ec83359418',
    messagingSenderId: '739793864137',
    projectId: 'trivia-62cc9',
    databaseURL: 'https://trivia-62cc9-default-rtdb.firebaseio.com',
    storageBucket: 'trivia-62cc9.appspot.com',
    iosBundleId: 'com.example.triviaflutter',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyC0SzZIzYypJiNRe_PjS10YRoFmA7oWFFs',
    appId: '1:739793864137:ios:d88ae347a7e8ec83359418',
    messagingSenderId: '739793864137',
    projectId: 'trivia-62cc9',
    databaseURL: 'https://trivia-62cc9-default-rtdb.firebaseio.com',
    storageBucket: 'trivia-62cc9.appspot.com',
    iosBundleId: 'com.example.triviaflutter',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyBlbxU6FbCC_6TnXamrHEmwQuCRt5gGbK4',
    appId: '1:739793864137:web:71aaed59ca94387f359418',
    messagingSenderId: '739793864137',
    projectId: 'trivia-62cc9',
    authDomain: 'trivia-62cc9.firebaseapp.com',
    databaseURL: 'https://trivia-62cc9-default-rtdb.firebaseio.com',
    storageBucket: 'trivia-62cc9.appspot.com',
    measurementId: 'G-T5N4P2L8V9',
  );
}