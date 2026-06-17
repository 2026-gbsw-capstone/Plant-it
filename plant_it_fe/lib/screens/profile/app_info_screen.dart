part of '../app_screen.dart';

class AppInfoScreen extends StatelessWidget {
  const AppInfoScreen({super.key});

  static const _webBase = 'https://growve.siyoung.dev';

  Future<void> _openLink(String path) async {
    final uri = Uri.parse('$_webBase/#$path');
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 34, 16, 0),
              child: _TopBar(title: '앱 정보', onBack: () => context.pop()),
            ),
            const SizedBox(height: 40),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Growve',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
                  ),
                  SizedBox(height: 6),
                  Text(
                    'Version 1.0.0',
                    style: TextStyle(fontSize: 14, color: PlantItColors.muted),
                  ),
                  SizedBox(height: 16),
                  Text(
                    '문의: app-master@siyoung.dev',
                    style: TextStyle(fontSize: 14, color: PlantItColors.text),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                '약관 및 정책',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: PlantItColors.muted,
                ),
              ),
            ),
            const SizedBox(height: 4),
            _LegalLinkRow(label: '서비스 이용약관', onTap: () => _openLink('/terms')),
            _LegalLinkRow(label: '개인정보 처리방침', onTap: () => _openLink('/privacy')),
            _LegalLinkRow(
              label: '개인정보 제3자 제공 동의',
              onTap: () => _openLink('/third-party'),
            ),
            _LegalLinkRow(
              label: '개인정보 국외 이전 동의',
              onTap: () => _openLink('/overseas'),
            ),
          ],
        ),
      ),
    );
  }
}

class _LegalLinkRow extends StatelessWidget {
  const _LegalLinkRow({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Row(
          children: [
            Expanded(
              child: Text(
                label,
                style: const TextStyle(fontSize: 15, color: PlantItColors.text),
              ),
            ),
            const Icon(
              Icons.open_in_new,
              size: 18,
              color: PlantItColors.muted,
            ),
          ],
        ),
      ),
    );
  }
}
