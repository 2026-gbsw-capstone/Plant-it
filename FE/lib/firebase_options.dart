import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show TargetPlatform, defaultTargetPlatform, kIsWeb;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      throw UnsupportedError(
        'DefaultFirebaseOptions have not been configured for web.',
      );
    }

    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
      case TargetPlatform.windows:
      case TargetPlatform.linux:
      case TargetPlatform.fuchsia:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not configured for this platform.',
        );
    }
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDTbIzpBTQRHQLP3tZu2KSyTLscpzlHiIg',
    appId: '1:1030670601241:android:062d13e6a3d0ecf426ae88',
    messagingSenderId: '1030670601241',
    projectId: 'capstone2026-1-66eba',
    storageBucket: 'capstone2026-1-66eba.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCDN1WFTLzkkcGwptFpbKsu812TfhXVJwQ',
    appId: '1:1030670601241:ios:b9b87ce2c0072be326ae88',
    messagingSenderId: '1030670601241',
    projectId: 'capstone2026-1-66eba',
    storageBucket: 'capstone2026-1-66eba.firebasestorage.app',
    iosBundleId: 'dev.siyoung.app.frontend.frontend',
  );

}