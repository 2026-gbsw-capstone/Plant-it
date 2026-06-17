import 'package:go_router/go_router.dart';
import 'package:plant_it_fe/screens/app_screen.dart';
import 'package:plant_it_fe/screens/splash_screen.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(path: '/', builder: (context, state) => const SplashScreen()),
    GoRoute(
      path: '/onboarding',
      builder: (context, state) => const OnboardingScreen(),
    ),
    GoRoute(path: '/auth', builder: (context, state) => const AuthScreen()),
    GoRoute(
      path: '/auth/reset-password',
      builder: (context, state) => const PasswordResetScreen(),
    ),
    GoRoute(
      path: '/auth/google',
      builder: (context, state) => const GoogleAuthScreen(),
    ),
    GoRoute(path: '/home', builder: (context, state) => const PlantHomeShell()),
    GoRoute(
      path: '/profile',
      builder: (context, state) => const ProfileRouteScreen(),
    ),
    GoRoute(
      path: '/account',
      builder: (context, state) => const AccountScreen(),
    ),
    GoRoute(
      path: '/notifications',
      builder: (context, state) => const NotificationHistoryScreen(),
    ),
    GoRoute(
      path: '/stats',
      builder: (context, state) => const StatsScreen(),
    ),
    GoRoute(
      path: '/settings',
      builder: (context, state) => const SettingsScreen(),
    ),
    GoRoute(
      path: '/app-info',
      builder: (context, state) => const AppInfoScreen(),
    ),
    GoRoute(
      path: '/plants/:plantId',
      builder: (context, state) {
        final plantId =
            int.tryParse(state.pathParameters['plantId'] ?? '') ?? 0;
        return PlantDetailScreen(plantId: plantId);
      },
    ),
    GoRoute(
      path: '/plants/:plantId/chat',
      builder: (context, state) {
        final plantId =
            int.tryParse(state.pathParameters['plantId'] ?? '') ?? 0;
        return PlantChatScreen(plantId: plantId);
      },
    ),
    GoRoute(
      path: '/plants/:plantId/gallery',
      builder: (context, state) {
        final plantId =
            int.tryParse(state.pathParameters['plantId'] ?? '') ?? 0;
        return GrowthGalleryScreen(plantId: plantId);
      },
    ),
  ],
);
