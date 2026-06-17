part of '../app_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _controller = PageController();
  int _page = 0;

  void _next() {
    if (_page == 1) {
      // 슬라이드 끝 → 로그인/회원가입으로
      context.go('/auth');
      return;
    }
    _controller.nextPage(
      duration: const Duration(milliseconds: 260),
      curve: Curves.easeOut,
    );
  }

  void _skip() => context.go('/auth');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 20),
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () => context.go('/auth'),
                  child: const Text('건너뛰기'),
                ),
              ),
              Expanded(
                child: PageView(
                  controller: _controller,
                  onPageChanged: (value) => setState(() => _page = value),
                  children: const [
                    _OnboardingPage(
                      image: _fallbackPlantImage,
                      title: '내 식물의 오늘을\n가볍게 기록해요',
                      body: '물주기, 햇빛, 키 변화를 한눈에 확인하고 식물별 성장 일지를 남겨보세요.',
                    ),
                    _OnboardingPage(
                      image: 'assets/images/figma/cactus_large.png',
                      title: 'AI와 함께 식물 상태를\n빠르게 확인해요',
                      body: '사진을 올리면 상태를 분석하고 필요한 관리 팁을 자연스럽게 이어줍니다.',
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  _Dot(active: _page == 0),
                  const SizedBox(width: 8),
                  _Dot(active: _page == 1),
                  const Spacer(),
                  _PrimaryButton(
                    label: _page == 1 ? '시작하기' : '다음',
                    onTap: _next,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
