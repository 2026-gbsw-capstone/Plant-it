part of '../app_screen.dart';

// ─── 로그인 / 회원가입 (1단계) ─────────────────────────────────────────────────

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _confirmPassword = TextEditingController();
  final _resetCode = TextEditingController();
  bool _signupMode = false;
  bool _resetMode = false;
  bool _loading = false;
  bool _passwordObscured = true;
  bool _confirmPasswordObscured = true;
  int _resetStep = 1;
  String? _resetDevCode;
  String? _resetToken;

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    _confirmPassword.dispose();
    _resetCode.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_validateInputs()) return;
    setState(() => _loading = true);
    try {
      if (_resetMode) {
        await _submitPasswordReset();
      } else if (_signupMode) {
        // 회원가입 1단계: 이메일+비번 확인 후 유저네임 화면으로
        if (_password.text != _confirmPassword.text) {
          _showMessage('비밀번호가 일치하지 않아요.');
          return;
        }
        if (_password.text.length < 8) {
          _showMessage('비밀번호는 8자 이상 입력해주세요.');
          return;
        }
        // 유저네임 입력 화면으로 이동
        final result = await Navigator.push<bool>(
          context,
          MaterialPageRoute(
            builder: (_) => SignupNicknameScreen(
              email: _email.text.trim(),
              password: _password.text,
            ),
          ),
        );
        if (result == true && mounted) _enterApp();
      } else {
        await ApiService.instance.login(
          email: _email.text.trim(),
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

  Future<void> _submitPasswordReset() async {
    if (_resetStep == 1) {
      final devCode = await ApiService.instance.requestPasswordReset(
        _email.text.trim(),
      );
      if (!mounted) return;
      setState(() {
        _resetDevCode = devCode;
        _resetToken = null;
        _resetStep = 2;
      });
      _showMessage(devCode == null ? '인증 코드를 발송했어요.' : '개발 인증 코드: $devCode');
      return;
    }

    if (_resetStep == 2) {
      final resetToken = await ApiService.instance.verifyPasswordResetCode(
        email: _email.text.trim(),
        code: _resetCode.text.trim(),
      );
      if (!mounted) return;
      if (resetToken.isEmpty) {
        _showMessage('비밀번호 재설정 토큰을 받지 못했어요.');
        return;
      }
      setState(() {
        _resetToken = resetToken;
        _resetStep = 3;
      });
      return;
    }

    final resetToken = _resetToken;
    if (resetToken == null || resetToken.isEmpty) {
      _showMessage('비밀번호 재설정 토큰이 없어요. 인증 코드를 다시 확인해주세요.');
      setState(() => _resetStep = 2);
      return;
    }
    await ApiService.instance.resetPassword(
      resetToken: resetToken,
      newPassword: _password.text,
    );
    if (!mounted) return;
    _showMessage('비밀번호가 변경되었어요. 다시 로그인해주세요.');
    setState(() {
      _resetMode = false;
      _resetStep = 1;
      _resetDevCode = null;
      _resetToken = null;
      _password.clear();
      _confirmPassword.clear();
      _resetCode.clear();
    });
  }

  bool _validateInputs() {
    final email = _email.text.trim();
    if (email.isEmpty) {
      _showMessage('이메일을 입력해주세요.');
      return false;
    }
    if (_resetMode) {
      if (_resetStep >= 2 && _resetCode.text.trim().isEmpty) {
        _showMessage('인증 코드를 입력해주세요.');
        return false;
      }
      if (_resetStep == 3 && _password.text.isEmpty) {
        _showMessage('새 비밀번호를 입력해주세요.');
        return false;
      }
      return true;
    }
    if (_password.text.isEmpty) {
      _showMessage('비밀번호를 입력해주세요.');
      return false;
    }
    return true;
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
    final resetButtonLabel = switch (_resetStep) {
      1 => '인증 코드 받기',
      2 => '인증하기',
      _ => '비밀번호 변경',
    };

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(28, 54, 28, 24),
          children: [
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 78),
            TextField(
              controller: _email,
              enabled: !_resetMode || _resetStep == 1,
              keyboardType: TextInputType.emailAddress,
              decoration: _authInput(
                label: _signupMode ? '이메일' : '이메일 또는 유저네임',
                hint: 'example@mail.com',
              ),
            ),
            if (_resetMode && _resetStep >= 2) ...[
              const SizedBox(height: 16),
              TextField(
                controller: _resetCode,
                keyboardType: TextInputType.number,
                enabled: _resetStep == 2,
                decoration: _authInput(label: '인증 코드', hint: '000000'),
              ),
              if (_resetDevCode != null) ...[
                const SizedBox(height: 8),
                Text(
                  '개발 인증 코드: $_resetDevCode',
                  style: const TextStyle(
                    color: PlantItColors.muted,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ],
            if (!_resetMode || _resetStep == 3) ...[
              const SizedBox(height: 16),
              TextField(
                controller: _password,
                obscureText: _passwordObscured,
                decoration: _authInput(
                  label: _resetMode ? '새 비밀번호' : '비밀번호',
                  hint: '...',
                  suffixIcon: _PasswordVisibilityButton(
                    obscured: _passwordObscured,
                    onTap: () =>
                        setState(() => _passwordObscured = !_passwordObscured),
                  ),
                ),
              ),
            ],
            if (_signupMode && !_resetMode) ...[
              const SizedBox(height: 16),
              TextField(
                controller: _confirmPassword,
                obscureText: _confirmPasswordObscured,
                decoration: _authInput(
                  label: '비밀번호 재입력',
                  hint: '...',
                  suffixIcon: _PasswordVisibilityButton(
                    obscured: _confirmPasswordObscured,
                    onTap: () => setState(
                      () =>
                          _confirmPasswordObscured = !_confirmPasswordObscured,
                    ),
                  ),
                ),
              ),
            ],
            if (_resetMode && _resetStep == 3) ...[
              const SizedBox(height: 16),
              TextField(
                controller: _confirmPassword,
                obscureText: _confirmPasswordObscured,
                decoration: _authInput(
                  label: '새 비밀번호 재입력',
                  hint: '...',
                  suffixIcon: _PasswordVisibilityButton(
                    obscured: _confirmPasswordObscured,
                    onTap: () => setState(
                      () =>
                          _confirmPasswordObscured = !_confirmPasswordObscured,
                    ),
                  ),
                ),
              ),
            ],
            if (!_signupMode && !_resetMode) ...[
              const SizedBox(height: 14),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: _loading
                      ? null
                      : () => context.push('/auth/reset-password'),
                  child: const Text('비밀번호가 기억나지 않아요'),
                ),
              ),
            ],
            const SizedBox(height: 18),
            _PrimaryButton(
              label: _loading
                  ? '처리 중'
                  : (_resetMode ? resetButtonLabel : '확인'),
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
                    backgroundColor: Colors.white,
                    foregroundColor: PlantItColors.ink,
                    side: const BorderSide(color: PlantItColors.line, width: 1.2),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(26),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 20,
                        child: Image.asset('assets/images/g-logo 1.png'),
                      ),
                      const SizedBox(width: 15),
                      const Text('Google 계정으로 계속'),
                    ],
                  ),
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
                        if (_resetMode) {
                          _resetMode = false;
                          _resetStep = 1;
                          _resetDevCode = null;
                          _resetToken = null;
                          _resetCode.clear();
                          _password.clear();
                          _confirmPassword.clear();
                        } else {
                          _signupMode = !_signupMode;
                          _confirmPassword.clear();
                        }
                      }),
                child: Text(
                  _resetMode
                      ? '로그인으로 돌아가기'
                      : (_signupMode
                          ? '이미 계정이 있나요? 로그인'
                          : '아직 계정이 없나요? 회원가입'),
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

// ─── 회원가입 2단계: 유저네임 ────────────────────────────────────────────────

class SignupNicknameScreen extends StatefulWidget {
  const SignupNicknameScreen({
    required this.email,
    required this.password,
    super.key,
  });

  final String email;
  final String password;

  @override
  State<SignupNicknameScreen> createState() => _SignupNicknameScreenState();
}

class _SignupNicknameScreenState extends State<SignupNicknameScreen> {
  final _nickname = TextEditingController();
  bool _loading = false;
  String? _errorText;

  @override
  void dispose() {
    _nickname.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final nickname = _nickname.text.trim();
    if (nickname.isEmpty) {
      setState(() => _errorText = '유저네임을 입력해주세요.');
      return;
    }
    setState(() {
      _loading = true;
      _errorText = null;
    });
    try {
      await ApiService.instance.signup(
        email: widget.email,
        password: widget.password,
        nickname: nickname,
      );
      await FirebaseMessagingService.instance.registerCurrentTokenIfPossible();
      if (mounted) {
        // 회원가입 완료 → 환영 화면
        final welcomed = await Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => SignupWelcomeScreen(nickname: nickname),
          ),
        );
        if (welcomed == true && context.mounted) {
          Navigator.pop(context, true);
        }
      }
    } catch (error) {
      final msg = error.toString();
      setState(() {
        _errorText = msg.contains('닉네임') || msg.contains('nickname')
            ? '누군가 이미 사용중인 유저네임이에요.'
            : msg;
      });
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 16, 16, 0),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_back),
                  ),
                  const Expanded(
                    child: Text(
                      '회원가입',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const SizedBox(width: 48),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(24, 40, 24, 24),
                children: [
                  const Text(
                    '회원가입을 마치려면 유저네임을 정해 주세요',
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 32),
                  const Text(
                    '유저네임',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: PlantItColors.ink,
                    ),
                  ),
                  const SizedBox(height: 4),
                  TextField(
                    controller: _nickname,
                    autofocus: true,
                    onSubmitted: (_) => _submit(),
                    decoration: const InputDecoration(
                      hintText: '...',
                      hintStyle: TextStyle(color: PlantItColors.muted),
                      border: UnderlineInputBorder(
                        borderSide: BorderSide(color: PlantItColors.line),
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: PlantItColors.line),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: PlantItColors.green,
                          width: 1.4,
                        ),
                      ),
                      contentPadding: EdgeInsets.fromLTRB(0, 8, 0, 10),
                    ),
                  ),
                  if (_errorText != null) ...[
                    const SizedBox(height: 8),
                    Text(
                      _errorText!,
                      style: const TextStyle(
                        color: Color(0xFFB94040),
                        fontSize: 13,
                      ),
                    ),
                  ],
                  const SizedBox(height: 32),
                  _PrimaryButton(
                    label: _loading ? '처리 중' : '확인',
                    expanded: true,
                    onTap: _loading ? null : _submit,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PasswordVisibilityButton extends StatelessWidget {
  const _PasswordVisibilityButton({
    required this.obscured,
    required this.onTap,
  });

  final bool obscured;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onTap,
      icon: _NavIcon(
        obscured ? 'assets/icons/eye-closed.svg' : 'assets/icons/eye-open.svg',
        color: PlantItColors.muted,
      ),
    );
  }
}

// ─── 회원가입 환영 화면 ───────────────────────────────────────────────────────

class SignupWelcomeScreen extends StatelessWidget {
  const SignupWelcomeScreen({required this.nickname, super.key});

  final String nickname;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 60, 24, 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '환영해요, $nickname님',
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                '이제 ${nickname}님의 첫 식물을 등록할 시간이에요.',
                style: const TextStyle(fontSize: 15, height: 1.5),
              ),
              const Spacer(),
              _PrimaryButton(
                label: '식물 등록하기',
                expanded: true,
                onTap: () {
                  // 홈으로 이동 후 식물 추가 시트
                  context.go('/home');
                },
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: OutlinedButton(
                  onPressed: () => context.go('/home'),
                  style: OutlinedButton.styleFrom(
                    backgroundColor: const Color(0xFFEDE8DF),
                    foregroundColor: PlantItColors.text,
                    side: BorderSide.none,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(26),
                    ),
                  ),
                  child: const Text('나중에 할게요'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
