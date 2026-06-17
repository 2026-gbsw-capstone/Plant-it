import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../theme.dart';

/// Cloudflare R2에 업로드한 APK의 공개 URL.
/// R2 버킷 생성 후 아래 값을 실제 URL로 교체하세요.
///   - 커스텀 도메인 연결 시:  https://dl.growve.siyoung.dev/growve.apk
///   - r2.dev 개발 URL 사용 시: https://pub-XXXXXXXX.r2.dev/growve.apk
const apkDownloadUrl = 'https://dt.growve.siyoung.dev/growve.apk';

class Main extends StatelessWidget {
  const Main({super.key});

  Future<void> _downloadApk() async {
    await launchUrl(
      Uri.parse(apkDownloadUrl),
      webOnlyWindowName: '_self',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GrowveColors.cream,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 480),
            child: ListView(
              padding: const EdgeInsets.fromLTRB(28, 48, 28, 32),
              shrinkWrap: true,
              children: [
                // 로고 / 워드마크
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.asset(
                    'assets/icons/growve_icon.png',
                    width: 76,
                    height: 76,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  'Growve',
                  style: TextStyle(
                    fontSize: 38,
                    fontWeight: FontWeight.w800,
                    color: GrowveColors.text,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  '식물과 함께 자라는 일상.\n앱을 내려받아 시작해 보세요.',
                  style: TextStyle(
                    fontSize: 15,
                    height: 1.6,
                    color: GrowveColors.muted,
                  ),
                ),
                const SizedBox(height: 36),

                // 다운로드 버튼
                _DownloadButton(
                  icon: Icons.android,
                  label: 'Android APK 다운로드',
                  filled: true,
                  onTap: _downloadApk,
                ),
                const SizedBox(height: 12),
                _DownloadButton(
                  icon: Icons.apple,
                  label: 'iOS (TestFlight) 준비 중',
                  filled: false,
                  onTap: null,
                ),

                const SizedBox(height: 48),
                const Divider(color: GrowveColors.line),
                const SizedBox(height: 16),
                const Text(
                  '약관 및 정책',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: GrowveColors.muted,
                  ),
                ),
                const SizedBox(height: 6),
                _LegalLink(label: '서비스 이용약관', route: '/terms'),
                _LegalLink(label: '개인정보 처리방침', route: '/privacy'),
                _LegalLink(label: '개인정보 제3자 제공 동의', route: '/third-party'),
                _LegalLink(label: '개인정보 국외 이전 동의', route: '/overseas'),

                const SizedBox(height: 24),
                const Text(
                  '© 2026 Growve. All rights reserved.',
                  style: TextStyle(fontSize: 12, color: GrowveColors.muted),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _DownloadButton extends StatelessWidget {
  const _DownloadButton({
    required this.icon,
    required this.label,
    required this.filled,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool filled;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final disabled = onTap == null;
    return Material(
      color: disabled
          ? GrowveColors.paper
          : (filled ? GrowveColors.green : GrowveColors.paper),
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          height: 56,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: filled && !disabled
                ? null
                : Border.all(color: GrowveColors.line),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 22,
                color: disabled
                    ? GrowveColors.muted
                    : (filled ? Colors.white : GrowveColors.text),
              ),
              const SizedBox(width: 10),
              Text(
                label,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: disabled
                      ? GrowveColors.muted
                      : (filled ? Colors.white : GrowveColors.text),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LegalLink extends StatelessWidget {
  const _LegalLink({required this.label, required this.route});

  final String label;
  final String route;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.of(context).pushNamed(route),
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
        child: Row(
          children: [
            Expanded(
              child: Text(
                label,
                style: const TextStyle(
                  fontSize: 15,
                  color: GrowveColors.text,
                ),
              ),
            ),
            const Icon(
              Icons.chevron_right,
              size: 20,
              color: GrowveColors.muted,
            ),
          ],
        ),
      ),
    );
  }
}
