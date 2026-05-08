import 'package:flutter/material.dart';
import 'package:plant_it_fe/app_router.dart';
import 'package:plant_it_fe/services/firebase_messaging_service.dart';
import 'package:plant_it_fe/theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FirebaseMessagingService.instance.initialize();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Plant-it',
      theme: PlantItTheme.light,
      routerConfig: appRouter,
    );
  }
}
