import 'package:flutter/material.dart';
import 'package:plant_it_fe/screens/ai/plant_chat_screen.dart';
import 'package:plant_it_fe/screens/auth/auth_screens.dart';
import 'package:plant_it_fe/screens/encyclopedia/encyclopedia_screens.dart';
import 'package:plant_it_fe/screens/home/home_screen.dart';
import 'package:plant_it_fe/screens/plant/plant_screens.dart';
import 'package:plant_it_fe/screens/shared/app_routes.dart';
import 'package:plant_it_fe/screens/shared/app_theme.dart';
import 'package:plant_it_fe/screens/shared/mock_data.dart';
import 'package:plant_it_fe/screens/splash_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Plant it',
      theme: AppTheme.light(),
      initialRoute: AppRoutes.splash,
      routes: {
        AppRoutes.splash: (context) => const SplashScreen(),
        AppRoutes.signIn: (context) => const SignInScreen(),
        AppRoutes.signUp: (context) => const SignUpScreen(),
        AppRoutes.googleSignUp: (context) => const GoogleSignUpScreen(),
        AppRoutes.passwordResetRequest: (context) =>
            const PasswordResetRequestScreen(),
        AppRoutes.passwordResetVerify: (context) =>
            const PasswordResetVerifyScreen(),
        AppRoutes.passwordResetComplete: (context) =>
            const PasswordResetCompleteScreen(),
        AppRoutes.main: (context) => const MainShellScreen(),
        AppRoutes.plantAdd: (context) => const PlantAddScreen(),
        AppRoutes.plantAddTable: (context) => const PlantAddTableScreen(),
        AppRoutes.plantChat: (context) => const PlantChatScreen(),
        AppRoutes.plantDetail: (context) {
          final plant = ModalRoute.of(context)!.settings.arguments as DemoPlant;
          return PlantDetailScreen(plant: plant);
        },
        AppRoutes.plantGrowthGallery: (context) {
          final plant = ModalRoute.of(context)!.settings.arguments as DemoPlant;
          return PlantGrowthGalleryScreen(plant: plant);
        },
        AppRoutes.plantGalleryAdd: (context) {
          final plant = ModalRoute.of(context)!.settings.arguments as DemoPlant;
          return PlantGalleryAddScreen(plant: plant);
        },
        AppRoutes.encyclopediaEntry: (context) {
          final guide =
              ModalRoute.of(context)!.settings.arguments as DemoCareGuide;
          return EncyclopediaEntryScreen(guide: guide);
        },
      },
    );
  }
}
