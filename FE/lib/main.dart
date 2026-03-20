import 'package:flutter/material.dart';
import 'package:frontend/screens/splash_scrren.dart';

import 'etc/app_theme.dart';
import 'etc/etc.dart';
import 'services/firebase_messaging_service.dart';
import 'services/notification_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService.initialize();
  await FirebaseMessagingService.initialize();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Plant Mate',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: etc.themePreference.themeMode,
      home: SplashScrren(),
    );
  }
}
