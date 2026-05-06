import 'package:flutter/material.dart';
import 'package:plant_it_fe/screens/shared/app_routes.dart';
import 'package:plant_it_fe/screens/shared/app_theme.dart';
import 'package:plant_it_fe/screens/shared/app_widgets.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PrototypeScaffold(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '식물 돌봄을\n잊지 않도록',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineLarge,
              ),
              const SizedBox(height: 20),
              const Text(
                '물주기와 성장 기록을 한눈에 관리해요.',
                textAlign: TextAlign.center,
                style: TextStyle(color: AppColors.subText),
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: () =>
                    Navigator.pushReplacementNamed(context, AppRoutes.signIn),
                child: const Text('시작하기'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
