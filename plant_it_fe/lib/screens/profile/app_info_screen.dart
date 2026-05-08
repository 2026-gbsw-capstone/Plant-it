part of '../app_screen.dart';

class AppInfoScreen extends StatelessWidget {
  const AppInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 34, 16, 28),
          children: [
            _TopBar(title: '앱 정보', onBack: () => context.pop()),
            const SizedBox(height: 68),
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(18),
                child: Image.asset(
                  'assets/images/figma/plant_pot.jpg',
                  width: 118,
                  height: 118,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 22),
            const Text(
              'Plant-it',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900),
            ),
            const SizedBox(height: 8),
            const Text(
              '반려식물과 함께하는 성장 기록',
              textAlign: TextAlign.center,
              style: TextStyle(color: PlantItColors.muted, fontSize: 13),
            ),
            const SizedBox(height: 46),
            const _InfoLine(label: '버전', value: '1.0.0'),
            const _InfoLine(label: '개발', value: 'Plant-it Capstone'),
            const _InfoLine(label: '문의', value: 'capstone-ec2.siyoung.dev'),
          ],
        ),
      ),
    );
  }
}

class _InfoLine extends StatelessWidget {
  const _InfoLine({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: PlantItColors.line)),
      ),
      child: Row(
        children: [
          Text(label, style: const TextStyle(color: PlantItColors.muted)),
          const Spacer(),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }
}
