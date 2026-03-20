import 'package:flutter/material.dart';

import '../services/auth_service.dart';
import 'login_screes.dart';
import 'main_screen.dart';

class SplashScrren extends StatefulWidget {
  const SplashScrren({super.key});

  @override
  State<SplashScrren> createState() => _SplashScrrenState();
}

class _SplashScrrenState extends State<SplashScrren> {
  final AuthService _authService = AuthService();

  @override
  void initState() {
    super.initState();
    _checkLogin();
  }

  Future<void> _checkLogin() async {
    try {
      final user = await _authService.restoreSession();

      if (!mounted) {
        return;
      }

      final nextScreen = user == null ? const LoginScrees() : const MainScreen();
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => nextScreen),
      );
    } catch (_) {
      if (!mounted) {
        return;
      }

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const LoginScrees()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SizedBox(
            width: 256,
            height: 256,
            child: Image.asset('assets/images/pea.png', fit: BoxFit.fill),
          ),
        ),
      ),
    );
  }
}
