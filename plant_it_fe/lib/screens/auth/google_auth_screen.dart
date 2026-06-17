part of '../app_screen.dart';

class GoogleAuthScreen extends StatefulWidget {
  const GoogleAuthScreen({super.key});

  @override
  State<GoogleAuthScreen> createState() => _GoogleAuthScreenState();
}

class _GoogleAuthScreenState extends State<GoogleAuthScreen> {
  bool _loading = false;

  Future<void> _continueWithGoogle() async {
    setState(() => _loading = true);
    try {
      await AuthService.instance.signInWithGoogle();
      await FirebaseMessagingService.instance.registerCurrentTokenIfPossible();
      if (!mounted) return;
      context.go('/home');
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(error.toString())));
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(28, 54, 28, 24),
          children: [
            Row(
              children: [
                IconButton(
                  onPressed: _loading ? null : () => context.go('/auth'),
                  icon: const Icon(Icons.arrow_back),
                ),
                const Expanded(
                  child: Text(
                    '회원가입',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
                  ),
                ),
                const SizedBox(width: 48),
              ],
            ),
            const SizedBox(height: 86),
            const Text(
              'Google 계정으로\nPlant-it을 시작할까요?',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                height: 1.35,
              ),
            ),
            const SizedBox(height: 18),
            const Text(
              '선택한 Google 계정으로 로그인하거나 새 계정을 만들 수 있어요.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: PlantItColors.muted,
                fontSize: 13,
                height: 1.55,
              ),
            ),
            const SizedBox(height: 54),
            Container(
              height: 74,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: PlantItColors.paper,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: PlantItColors.line),
              ),
              child: Row(
                children: [
                  Container(
                    width: 42,
                    height: 42,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: const Center(
                      child: Text(
                        'G',
                        style: TextStyle(
                          color: Color(0xFF4285F4),
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  const Expanded(
                    child: Text(
                      'Google 계정',
                      style: TextStyle(fontWeight: FontWeight.w700),
                    ),
                  ),
                  const Icon(Icons.chevron_right),
                ],
              ),
            ),
            const SizedBox(height: 28),
            _PrimaryButton(
              label: _loading ? '처리 중' : '확인',
              expanded: true,
              onTap: _loading ? null : _continueWithGoogle,
            ),
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: _loading ? null : () => context.go('/auth'),
                child: const Text('이미 계정이 있어요? 로그인'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
