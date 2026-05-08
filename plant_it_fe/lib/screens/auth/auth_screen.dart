part of '../app_screen.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _nickname = TextEditingController();
  bool _signupMode = false;
  bool _resetMode = false;
  bool _loading = false;

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    _nickname.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    setState(() => _loading = true);
    try {
      if (_resetMode) {
        final devCode = await ApiService.instance.requestPasswordReset(
          _email.text,
        );
        if (!mounted) return;
        _showMessage(devCode == null ? '인증 코드를 발송했어요.' : '개발 인증 코드: $devCode');
      } else if (_signupMode) {
        await ApiService.instance.signup(
          email: _email.text,
          password: _password.text,
          nickname: _nickname.text,
        );
        await FirebaseMessagingService.instance
            .registerCurrentTokenIfPossible();
        _enterApp();
      } else {
        await ApiService.instance.login(
          email: _email.text,
          password: _password.text,
        );
        await FirebaseMessagingService.instance
            .registerCurrentTokenIfPossible();
        _enterApp();
      }
    } catch (error) {
      if (mounted) _showMessage(error.toString());
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  void _enterApp() {
    if (!mounted) return;
    context.go('/home');
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    final title = _resetMode ? '비밀번호 찾기' : (_signupMode ? '회원가입' : '로그인');

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(28, 54, 28, 24),
          children: [
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 78),
            TextField(
              controller: _email,
              keyboardType: TextInputType.emailAddress,
              decoration: _authInput(
                label: _resetMode ? '이메일 또는 유저네임' : '이메일',
                hint: _resetMode ? 'example@mail.com' : 'example@mail.com',
              ),
            ),
            if (_signupMode && !_resetMode) ...[
              const SizedBox(height: 16),
              TextField(
                controller: _nickname,
                decoration: _authInput(label: '유저네임', hint: '...'),
              ),
            ],
            if (!_resetMode) ...[
              const SizedBox(height: 16),
              TextField(
                controller: _password,
                obscureText: true,
                decoration: _authInput(
                  label: '비밀번호',
                  hint: '...',
                  suffixIcon: const Icon(Icons.visibility_off_outlined),
                ),
              ),
            ],
            if (_signupMode && !_resetMode) ...[
              const SizedBox(height: 16),
              TextField(
                obscureText: true,
                decoration: _authInput(label: '비밀번호 재입력', hint: '...'),
              ),
            ],
            if (!_signupMode && !_resetMode) ...[
              const SizedBox(height: 14),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: _loading
                      ? null
                      : () => setState(() {
                          _resetMode = true;
                          _signupMode = false;
                        }),
                  child: const Text('비밀번호가 기억나지 않아요'),
                ),
              ),
            ],
            const SizedBox(height: 18),
            _PrimaryButton(
              label: _loading
                  ? '처리 중'
                  : (_resetMode ? '확인' : (_signupMode ? '확인' : '확인')),
              expanded: true,
              onTap: _loading ? null : _submit,
            ),
            if (!_resetMode) ...[
              const SizedBox(height: 12),
              SizedBox(
                height: 48,
                child: OutlinedButton(
                  onPressed: _loading ? null : () => context.go('/auth/google'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: PlantItColors.ink,
                    side: const BorderSide(color: PlantItColors.ink),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),
                  child: const Text('G  Google 계정으로 계속'),
                ),
              ),
            ],
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: _loading
                    ? null
                    : () => setState(() {
                        _resetMode = false;
                        _signupMode = !_signupMode;
                      }),
                child: Text(
                  _resetMode
                      ? '로그인으로 돌아가기'
                      : (_signupMode ? '이미 계정이 있어요? 로그인' : '아직 계정이 없나요? 회원가입'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  InputDecoration _authInput({
    required String label,
    required String hint,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      suffixIcon: suffixIcon,
      filled: false,
      contentPadding: const EdgeInsets.fromLTRB(0, 8, 0, 10),
      labelStyle: const TextStyle(
        color: PlantItColors.ink,
        fontSize: 12,
        fontWeight: FontWeight.w600,
      ),
      hintStyle: const TextStyle(color: PlantItColors.muted),
      border: const UnderlineInputBorder(
        borderSide: BorderSide(color: PlantItColors.line),
      ),
      enabledBorder: const UnderlineInputBorder(
        borderSide: BorderSide(color: PlantItColors.line),
      ),
      focusedBorder: const UnderlineInputBorder(
        borderSide: BorderSide(color: PlantItColors.green, width: 1.4),
      ),
    );
  }
}
