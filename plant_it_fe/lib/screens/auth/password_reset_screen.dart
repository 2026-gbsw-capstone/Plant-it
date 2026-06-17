part of '../app_screen.dart';

class PasswordResetScreen extends StatefulWidget {
  const PasswordResetScreen({super.key});

  @override
  State<PasswordResetScreen> createState() => _PasswordResetScreenState();
}

class _PasswordResetScreenState extends State<PasswordResetScreen> {
  int _step = 1; // 1: email, 2: code, 3: new password
  final _email = TextEditingController();
  final _code = TextEditingController();
  final _password = TextEditingController();
  final _confirm = TextEditingController();
  bool _obscure1 = true, _obscure2 = true;
  bool _loading = false;
  String? _resetToken;
  String? _devCode;

  @override
  void dispose() {
    _email.dispose();
    _code.dispose();
    _password.dispose();
    _confirm.dispose();
    super.dispose();
  }

  Future<void> _next() async {
    setState(() => _loading = true);
    try {
      if (_step == 1) {
        final email = _email.text.trim();
        if (email.isEmpty) {
          _show('이메일을 입력해 주세요.');
          return;
        }
        final devCode = await ApiService.instance.requestPasswordReset(email);
        if (!mounted) return;
        setState(() {
          _devCode = devCode;
          _step = 2;
        });
        if (devCode != null) _show('개발 인증 코드: $devCode');
      } else if (_step == 2) {
        final code = _code.text.trim();
        if (code.isEmpty) {
          _show('인증 코드를 입력해 주세요.');
          return;
        }
        final token = await ApiService.instance.verifyPasswordResetCode(
          email: _email.text.trim(),
          code: code,
        );
        if (!mounted) return;
        if (token.isEmpty) {
          _show('인증 코드가 올바르지 않아요.');
          return;
        }
        setState(() {
          _resetToken = token;
          _step = 3;
        });
      } else {
        if (_password.text.length < 8) {
          _show('비밀번호는 8자 이상이어야 해요.');
          return;
        }
        if (_password.text != _confirm.text) {
          _show('비밀번호가 일치하지 않아요.');
          return;
        }
        await ApiService.instance.resetPassword(
          resetToken: _resetToken!,
          newPassword: _password.text,
        );
        if (!mounted) return;
        _show('비밀번호가 변경됐어요. 다시 로그인해 주세요.');
        context.go('/auth');
      }
    } catch (error) {
      if (mounted) _show(error.toString());
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  void _show(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 16, 16, 0),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () {
                      if (_step > 1) {
                        setState(() => _step--);
                      } else {
                        context.pop();
                      }
                    },
                    icon: const Icon(Icons.arrow_back),
                  ),
                  const Expanded(
                    child: Text(
                      '비밀번호 재설정',
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
                  // Step 별 안내 텍스트
                  Text(
                    switch (_step) {
                      1 => '찾으려는 계정의 이메일을 입력해 주세요',
                      2 => '이메일로 전송된 6자리 코드를 입력해 주세요',
                      _ => '새 비밀번호를 설정해 주세요',
                    },
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 32),
                  // Step 1: 이메일
                  if (_step == 1) ...[
                    const Text(
                      '이메일',
                      style: TextStyle(fontSize: 12, color: PlantItColors.muted),
                    ),
                    const SizedBox(height: 4),
                    TextField(
                      controller: _email,
                      keyboardType: TextInputType.emailAddress,
                      autofocus: true,
                      decoration: _resetInput(hint: '...'),
                    ),
                  ],
                  // Step 2: 6자리 코드
                  if (_step == 2) ...[
                    if (_devCode != null)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Text(
                          '개발 인증 코드: $_devCode',
                          style: const TextStyle(
                            color: PlantItColors.muted,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    TextField(
                      controller: _code,
                      keyboardType: TextInputType.number,
                      maxLength: 6,
                      autofocus: true,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.w300,
                        letterSpacing: 14,
                        color: PlantItColors.muted,
                      ),
                      decoration: const InputDecoration(
                        hintText: '000000',
                        hintStyle: TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.w300,
                          letterSpacing: 14,
                          color: Color(0xFFCCC5BB),
                        ),
                        counterText: '',
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                      ),
                    ),
                  ],
                  // Step 3: 새 비밀번호
                  if (_step == 3) ...[
                    const Text(
                      '비밀번호',
                      style: TextStyle(fontSize: 12, color: PlantItColors.muted),
                    ),
                    const SizedBox(height: 4),
                    TextField(
                      controller: _password,
                      obscureText: _obscure1,
                      autofocus: true,
                      decoration: _resetInput(
                        hint: '...',
                        suffix: IconButton(
                          onPressed: () =>
                              setState(() => _obscure1 = !_obscure1),
                          icon: Icon(
                            _obscure1
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                            color: PlantItColors.muted,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      '비밀번호 재입력',
                      style: TextStyle(fontSize: 12, color: PlantItColors.muted),
                    ),
                    const SizedBox(height: 4),
                    TextField(
                      controller: _confirm,
                      obscureText: _obscure2,
                      decoration: _resetInput(
                        hint: '...',
                        suffix: IconButton(
                          onPressed: () =>
                              setState(() => _obscure2 = !_obscure2),
                          icon: Icon(
                            _obscure2
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                            color: PlantItColors.muted,
                          ),
                        ),
                      ),
                    ),
                  ],
                  const SizedBox(height: 32),
                  _PrimaryButton(
                    label: _loading
                        ? '처리 중'
                        : (_step == 3 ? '확인' : '다음'),
                    expanded: true,
                    onTap: _loading ? null : _next,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  InputDecoration _resetInput({required String hint, Widget? suffix}) {
    return InputDecoration(
      hintText: hint,
      suffixIcon: suffix,
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
      contentPadding: const EdgeInsets.fromLTRB(0, 8, 0, 10),
    );
  }
}
