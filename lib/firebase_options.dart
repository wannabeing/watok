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
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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
    apiKey: 'AIzaSyDAx-BBS7aH-ADrLliOv0H5LCt9_S6Rrbs',
    appId: '1:974213657023:web:f5386296ab557cf985b10a',
    messagingSenderId: '974213657023',
    projectId: 'my-watok',
    authDomain: 'my-watok.firebaseapp.com',
    storageBucket: 'my-watok.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBf0WpkwTPieQoLA6gPN8mnI8FWOy78DF4',
    appId: '1:974213657023:android:421400ea7620f3c885b10a',
    messagingSenderId: '974213657023',
    projectId: 'my-watok',
    storageBucket: 'my-watok.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCCRKVbsH0VlNqoALgAGRM9xCi4t8IiaLM',
    appId: '1:974213657023:ios:eaa4e7c4ae7eb85085b10a',
    messagingSenderId: '974213657023',
    projectId: 'my-watok',
    storageBucket: 'my-watok.appspot.com',
    iosClientId: '974213657023-fpnfen2ermh181lpa15hl72jnhcrs5gv.apps.googleusercontent.com',
    iosBundleId: 'com.wannabeing.watokApp',
  );
}