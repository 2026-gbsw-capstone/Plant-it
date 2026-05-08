part of '../app_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 34, 16, 28),
          children: [
            _TopBar(title: '설정', onBack: () => context.pop()),
            const SizedBox(height: 34),
            _SettingsOption(
              icon: Icons.notifications_none,
              title: '알림',
              subtitle: '물주기와 성장 기록 알림',
              trailing: Switch(value: true, onChanged: (_) {}),
            ),
            _SettingsOption(
              icon: Icons.water_drop_outlined,
              title: '물주기 알림',
              subtitle: '예정일에 푸시 알림 받기',
              trailing: Switch(value: true, onChanged: (_) {}),
            ),
            _SettingsOption(
              icon: Icons.eco_outlined,
              title: '식물 건강 알림',
              subtitle: '주의가 필요한 식물 먼저 보기',
              trailing: Switch(value: true, onChanged: (_) {}),
            ),
            const SizedBox(height: 18),
            _SettingsOption(
              icon: Icons.info_outline,
              title: '앱 정보',
              subtitle: '버전과 서비스 안내',
              onTap: () => context.push('/app-info'),
            ),
          ],
        ),
      ),
    );
  }
}

class _SettingsOption extends StatelessWidget {
  const _SettingsOption({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.trailing,
    this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        height: 76,
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 14),
        decoration: BoxDecoration(
          color: PlantItColors.paper,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Icon(icon, color: PlantItColors.ink),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      color: PlantItColors.muted,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            trailing ?? const Icon(Icons.chevron_right),
          ],
        ),
      ),
    );
  }
}
