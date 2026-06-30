import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:plant_it_fe/services/api_service.dart';
import 'package:plant_it_fe/theme.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool _checkingSession = true;

  @override
  void initState() {
    super.initState();
    _routeSignedInUser();
  }

  Future<void> _routeSignedInUser() async {
    try {
      final hasSession = await ApiService.instance.hasSession();
      if (!mounted) return;
      if (hasSession) {
        context.go('/home');
        return;
      }
    } catch (_) {
      if (!mounted) return;
    }
    setState(() => _checkingSession = false);
  }

  @override
  Widget build(BuildContext context) {
    if (_checkingSession) {
      return const Scaffold(backgroundColor: PlantItColors.cream);
    }

    return Scaffold(
      backgroundColor: PlantItColors.paper,
      body: Stack(
        fit: StackFit.expand,
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/figma/plant_pot.jpg',
              fit: BoxFit.cover,
              alignment: Alignment.bottomCenter,
            ),
          ),
          const DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xF7FFFCF6),
                  Color(0xCCFFFCF6),
                  Color(0x00FFFCF6),
                ],
                stops: [0, .42, .72],
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 126, 16, 34),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '마음의 평온을 찾는\n식물과의 여정',
                    style: TextStyle(
                      color: PlantItColors.ink,
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                      height: 1.35,
                    ),
                  ),
                  const Spacer(),
                  const Spacer(),
                  const Spacer(),
                  const Spacer(),
                  Center(
                    child: SizedBox(
                      width: 126,
                      height: 46,
                      child: FilledButton(
                        onPressed: () => context.go('/auth'),
                        style: FilledButton.styleFrom(
                          backgroundColor: PlantItColors.paper,
                          foregroundColor: PlantItColors.ink,
                          elevation: 6,
                          shadowColor: const Color(0x26000000),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(23),
                          ),
                        ),
                        child: const Text(
                          '시작',
                          style: TextStyle(fontWeight: FontWeight.w700),
                        ),
                      ),
                    ),
                  ),
                  const Spacer(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
