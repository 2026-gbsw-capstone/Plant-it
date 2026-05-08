part of '../app_screen.dart';

class ProfileTab extends StatelessWidget {
  const ProfileTab({required this.user, super.key});

  final UserModel user;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 28),
      children: [
        const Text(
          '마이페이지',
          style: TextStyle(fontSize: 26, fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 18),
        Container(
          padding: const EdgeInsets.all(18),
          decoration: _cardDecoration(),
          child: Row(
            children: [
              _Avatar(url: user.profileImageUrl),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user.nickname,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      user.email,
                      style: const TextStyle(color: PlantItColors.muted),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 18),
        const _MenuTile(icon: 'assets/icons/bell.svg', title: '알림 설정'),
        const _MenuTile(icon: 'assets/icons/lock-closed.svg', title: '비밀번호 변경'),
        _MenuTile(
          icon: 'assets/icons/back.svg',
          title: '로그아웃',
          onTap: () async {
            await ApiService.instance.logout();
            await AuthService.instance.signOut();
            if (!context.mounted) return;
            context.go('/auth');
          },
        ),
      ],
    );
  }
}
