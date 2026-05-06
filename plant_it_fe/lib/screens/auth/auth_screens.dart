import 'package:flutter/material.dart';
import 'package:plant_it_fe/screens/shared/app_routes.dart';
import 'package:plant_it_fe/screens/shared/app_theme.dart';
import 'package:plant_it_fe/screens/shared/app_widgets.dart';

class SignInScreen extends StatelessWidget {
  const SignInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return _AuthScaffold(
      title: '로그인',
      children: [
        const UnderlineTextField(
          label: '이메일 또는 유저네임',
          hint: 'example@mail.com',
        ),
        const SizedBox(height: 18),
        const UnderlineTextField(
          label: '비밀번호',
          obscureText: true,
          suffixIcon: AssetIcon(name: 'eye-closed'),
        ),
        const SizedBox(height: 14),
        Align(
          alignment: Alignment.centerRight,
          child: TextButton(
            onPressed: () =>
                Navigator.pushNamed(context, AppRoutes.passwordResetRequest),
            child: const Text(
              '비밀번호가 기억나지 않아요',
              style: TextStyle(color: AppColors.text, fontSize: 16),
            ),
          ),
        ),
        const SizedBox(height: 22),
        ElevatedButton(
          onPressed: () =>
              Navigator.pushReplacementNamed(context, AppRoutes.main),
          child: const Text('확인'),
        ),
        const SizedBox(height: 16),
        _GoogleButton(
          onPressed: () => Navigator.pushNamed(context, AppRoutes.googleSignUp),
        ),
        const SizedBox(height: 16),
        Align(
          alignment: Alignment.centerRight,
          child: TextButton(
            onPressed: () => Navigator.pushNamed(context, AppRoutes.signUp),
            child: const Text(
              '아직 계정이 없나요? 회원가입',
              style: TextStyle(color: AppColors.text, fontSize: 16),
            ),
          ),
        ),
      ],
    );
  }
}

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return _AuthScaffold(
      title: '회원가입',
      children: [
        const UnderlineTextField(label: '이메일'),
        const SizedBox(height: 18),
        const UnderlineTextField(label: '유저네임'),
        const SizedBox(height: 18),
        const UnderlineTextField(
          label: '비밀번호',
          obscureText: true,
          suffixIcon: AssetIcon(name: 'eye-closed'),
        ),
        const SizedBox(height: 18),
        const UnderlineTextField(
          label: '비밀번호 재입력',
          obscureText: true,
          suffixIcon: AssetIcon(name: 'eye-closed'),
        ),
        const SizedBox(height: 48),
        ElevatedButton(
          onPressed: () =>
              Navigator.pushReplacementNamed(context, AppRoutes.main),
          child: const Text('확인'),
        ),
        const SizedBox(height: 16),
        _GoogleButton(
          onPressed: () => Navigator.pushNamed(context, AppRoutes.googleSignUp),
        ),
        const SizedBox(height: 16),
        Align(
          alignment: Alignment.centerRight,
          child: TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              '이미 계정이 있나요? 로그인',
              style: TextStyle(color: AppColors.text, fontSize: 16),
            ),
          ),
        ),
      ],
    );
  }
}

class GoogleSignUpScreen extends StatelessWidget {
  const GoogleSignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return _AuthScaffold(
      title: '회원가입',
      children: [
        const UnderlineTextField(label: '유저네임'),
        const SizedBox(height: 18),
        const UnderlineTextField(label: '이메일', hint: 'google@example.com'),
        const SizedBox(height: 48),
        ElevatedButton(
          onPressed: () =>
              Navigator.pushReplacementNamed(context, AppRoutes.main),
          child: const Text('확인'),
        ),
      ],
    );
  }
}

class PasswordResetRequestScreen extends StatelessWidget {
  const PasswordResetRequestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return _AuthScaffold(
      title: '비밀번호 재설정',
      children: [
        const UnderlineTextField(label: '이메일 또는 유저네임'),
        const SizedBox(height: 34),
        ElevatedButton(
          onPressed: () =>
              Navigator.pushNamed(context, AppRoutes.passwordResetVerify),
          child: const Text('확인'),
        ),
      ],
    );
  }
}

class PasswordResetVerifyScreen extends StatelessWidget {
  const PasswordResetVerifyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return _AuthScaffold(
      title: '비밀번호 재설정',
      children: [
        const UnderlineTextField(label: '인증코드'),
        const SizedBox(height: 34),
        ElevatedButton(
          onPressed: () =>
              Navigator.pushNamed(context, AppRoutes.passwordResetComplete),
          child: const Text('확인'),
        ),
      ],
    );
  }
}

class PasswordResetCompleteScreen extends StatelessWidget {
  const PasswordResetCompleteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return _AuthScaffold(
      title: '비밀번호 재설정',
      children: [
        const UnderlineTextField(
          label: '비밀번호',
          obscureText: true,
          suffixIcon: AssetIcon(name: 'eye-closed'),
        ),
        const SizedBox(height: 18),
        const UnderlineTextField(
          label: '비밀번호 재입력',
          obscureText: true,
          suffixIcon: AssetIcon(name: 'eye-closed'),
        ),
        const SizedBox(height: 34),
        ElevatedButton(
          onPressed: () => Navigator.pushNamedAndRemoveUntil(
            context,
            AppRoutes.signIn,
            (_) => false,
          ),
          child: const Text('확인'),
        ),
      ],
    );
  }
}

class _AuthScaffold extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const _AuthScaffold({required this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PrototypeScaffold(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 72, 16, 24),
          child: Column(
            children: [
              Text(title, style: Theme.of(context).textTheme.headlineMedium),
              const SizedBox(height: 86),
              ...children,
            ],
          ),
        ),
      ),
    );
  }
}

class _GoogleButton extends StatelessWidget {
  final VoidCallback onPressed;

  const _GoogleButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        minimumSize: const Size.fromHeight(52),
        foregroundColor: AppColors.text,
        side: const BorderSide(color: AppColors.text),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(26)),
      ),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'G',
            style: TextStyle(
              color: Color(0xFF4285F4),
              fontWeight: FontWeight.w900,
              fontSize: 24,
            ),
          ),
          SizedBox(width: 10),
          Text('Google 계정으로 계속', style: TextStyle(fontSize: 18)),
        ],
      ),
    );
  }
}
