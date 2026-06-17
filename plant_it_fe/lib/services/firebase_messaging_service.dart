import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:plant_it_fe/services/api_service.dart';

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await FirebaseMessagingService.instance.initializeFirebase();
}

class FirebaseMessagingService {
  FirebaseMessagingService._();

  static final FirebaseMessagingService instance = FirebaseMessagingService._();

  bool _firebaseReady = false;
  bool _messagingReady = false;

  bool get firebaseReady => _firebaseReady;

  Future<void> initialize() async {
    await initializeFirebase();
    if (!_firebaseReady || _messagingReady) return;

    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
    FirebaseMessaging.instance.onTokenRefresh.listen(_registerTokenSafely);
    _messagingReady = true;
  }

  Future<void> initializeFirebase() async {
    if (_firebaseReady) return;
    try {
      await Firebase.initializeApp();
      _firebaseReady = true;
    } catch (error, stackTrace) {
      debugPrint('Firebase initialization skipped: $error');
      debugPrintStack(stackTrace: stackTrace);
    }
  }

  Future<void> registerCurrentTokenIfPossible() async {
    if (!_firebaseReady) return;
    try {
      await FirebaseMessaging.instance.requestPermission();
      final token = await FirebaseMessaging.instance.getToken();
      if (token == null || token.isEmpty) return;
      await _registerTokenSafely(token);
    } catch (error) {
      debugPrint('FCM token registration skipped: $error');
    }
  }

  Future<void> _registerTokenSafely(String token) async {
    try {
      await ApiService.instance.registerPushToken(token);
    } catch (error) {
      debugPrint('FCM token registration failed: $error');
    }
  }
}
