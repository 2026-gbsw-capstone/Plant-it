import 'package:flutter/material.dart';
import 'package:plant_it_fe/screens/shared/app_routes.dart';
import 'package:plant_it_fe/screens/shared/app_theme.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset('assets/images/splash bg.png', fit: BoxFit.cover),
          Container(color: Colors.white.withValues(alpha: 0.08)),
          Padding(
            padding: EdgeInsets.fromLTRB(16, 190, 16, 118),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '식물이 죽으면\n너도 죽으세여 :)',
                  style: Theme.of(context).textTheme.displayLarge,
                ),
                Spacer(),
                Center(
                  child: SizedBox(
                    width: 176,
                    height: 54,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushReplacementNamed(
                          context,
                          AppRoutes.signIn,
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white.withValues(alpha: 0.78),
                        foregroundColor: AppColors.text,
                        shadowColor: Colors.black.withValues(alpha: 0.24),
                        elevation: 8,
                      ),
                      child: Text('시작하기'),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
