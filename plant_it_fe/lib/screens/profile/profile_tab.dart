part of '../app_screen.dart';

class ProfileTab extends StatelessWidget {
  const ProfileTab({required this.user, super.key});

  final UserModel user;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 46, 16, 40),
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: IconButton(
            onPressed: () => context.pop(),
            icon: const Icon(Icons.arrow_back),
            padding: EdgeInsets.zero,
          ),
        ),
        const SizedBox(height: 16),
        _ProfileMenuItem(
          icon: Icons.person_outline,
          label: '계정',
          onTap: () => context.push('/account'),
        ),
        _ProfileMenuItem(
          icon: Icons.notifications_outlined,
          label: '알림',
          onTap: () => context.push('/notifications'),
        ),
        _ProfileMenuItem(
          icon: Icons.bar_chart_outlined,
          label: '사용 통계',
          onTap: () => context.push('/stats'),
        ),
        _ProfileMenuItem(
          icon: Icons.info_outline,
          label: '앱 정보',
          onTap: () => context.push('/app-info'),
        ),
        const SizedBox(height: 40),
        _ProfileMenuItem(
          icon: Icons.settings_outlined,
          label: '설정',
          onTap: () => context.push('/settings'),
        ),
        _ProfileMenuItem(
          icon: Icons.logout,
          label: '로그아웃',
          onTap: () => _showLogoutDialog(context),
        ),
      ],
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => Dialog(
        backgroundColor: const Color(0xFFF5F0E8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(22, 24, 22, 18),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '로그아웃',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 14),
              const Text('로그아웃 할까요?', style: TextStyle(fontSize: 14)),
              const SizedBox(height: 22),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text(
                      '취소',
                      style: TextStyle(color: PlantItColors.muted),
                    ),
                  ),
                  const SizedBox(width: 8),
                  TextButton(
                    onPressed: () async {
                      Navigator.pop(context);
                      await ApiService.instance.logout();
                      await AuthService.instance.signOut();
                      if (context.mounted) context.go('/auth');
                    },
                    child: const Text(
                      '확인',
                      style: TextStyle(
                        color: PlantItColors.green,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
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

class _ProfileMenuItem extends StatelessWidget {
  const _ProfileMenuItem({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 18),
        child: Row(
          children: [
            Icon(icon, size: 22, color: PlantItColors.text),
            const SizedBox(width: 16),
            Text(label, style: const TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}

// ─── 계정 화면 ───────────────────────────────────────────────────────────────

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  late Future<UserModel> _user;

  @override
  void initState() {
    super.initState();
    _user = ApiService.instance.getMe();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<UserModel>(
      future: _user,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Scaffold(body: _CenteredProgress());
        }
        final user = snapshot.data;
        if (user == null) {
          return const Scaffold(body: _CenteredProgress());
        }
        return Scaffold(
          body: SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(8, 16, 16, 0),
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () => context.pop(),
                        icon: const Icon(Icons.arrow_back),
                      ),
                      const Expanded(
                        child: Text(
                          '계정',
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
                const SizedBox(height: 40),
                // 프로필 사진
                ClipOval(
                  child: SizedBox(
                    width: 96,
                    height: 96,
                    child: _PlantImage(url: user.profileImageUrl),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  user.nickname,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  user.email,
                  style: const TextStyle(
                    fontSize: 13,
                    color: PlantItColors.muted,
                  ),
                ),
                const SizedBox(height: 48),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _AccountActionButton(
                        label: '비밀번호 변경',
                        onTap: () => _showChangePasswordDialog(context),
                      ),
                      const SizedBox(height: 40),
                      _AccountActionButton(
                        label: '계정 삭제',
                        onTap: () => _showDeleteDialog(context, user),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showChangePasswordDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => const _ChangePasswordDialog(),
    );
  }

  void _showDeleteDialog(BuildContext context, UserModel user) {
    showDialog(
      context: context,
      builder: (_) => _ConfirmThenPasswordDialog(
        title: '계정 삭제',
        confirmMessage: '정말 계정을 삭제할까요? 모든 데이터가 없어져요.',
        passwordMessage: '계정을 삭제하려면 현재 비밀번호를 입력해 주세요.',
        actionLabel: '삭제',
        actionColor: const Color(0xFFB94040),
        onConfirm: (password) async {
          await ApiService.instance.deleteAccount(password);
          await AuthService.instance.signOut();
        },
        onSuccess: (ctx) => ctx.go('/auth'),
      ),
    );
  }
}

class _AccountActionButton extends StatelessWidget {
  const _AccountActionButton({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color(0xFFEDE8DF),
      borderRadius: BorderRadius.circular(30),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(30),
        child: Container(
          height: 52,
          alignment: Alignment.center,
          child: Text(
            label,
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
          ),
        ),
      ),
    );
  }
}

// ─── 사용 통계 화면 ───────────────────────────────────────────────────────────

class StatsScreen extends StatefulWidget {
  const StatsScreen({super.key});

  @override
  State<StatsScreen> createState() => _StatsScreenState();
}

class _StatsScreenState extends State<StatsScreen> {
  late Future<_StatsData> _data;

  @override
  void initState() {
    super.initState();
    _data = _load();
  }

  Future<_StatsData> _load() async {
    final results = await Future.wait([
      ApiService.instance.getPlants(),
      ApiService.instance.getMe(),
    ]);
    final plants = results[0] as List<PlantModel>;
    final user = results[1] as UserModel;

    // 가장 오래 함께한 식물 (등록일 기준)
    final oldest = plants.isNotEmpty ? plants.first : null;

    // 물을 준 횟수 (lastWateredAt이 있는 식물 수)
    final wateredCount = plants.where((p) => p.lastWateredAt != null).length;

    return _StatsData(
      plants: plants,
      user: user,
      oldestPlant: oldest,
      wateredCount: wateredCount,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: FutureBuilder<_StatsData>(
          future: _data,
          builder: (context, snapshot) {
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(8, 16, 16, 0),
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () => context.pop(),
                        icon: const Icon(Icons.arrow_back),
                      ),
                      const Expanded(
                        child: Text(
                          '사용 통계',
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
                  child: snapshot.connectionState != ConnectionState.done
                      ? const _CenteredProgress()
                      : _buildGrid(snapshot.data),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildGrid(_StatsData? data) {
    final plants = data?.plants ?? [];
    final oldest = data?.oldestPlant;
    final daysWithOldest = oldest != null
        ? DateTime.now().difference(
            DateTime(
              DateTime.now().year - 1,
              DateTime.now().month,
              DateTime.now().day,
            ),
          ).inDays
        : 0;

    final items = [
      _StatItem(
        icon: Icons.notifications_outlined,
        label: '알림을 받은 횟수',
        value: '0',
      ),
      _StatItem(
        icon: Icons.water_drop_outlined,
        label: '물을 준 횟수',
        value: '${data?.wateredCount ?? 0}',
      ),
      _StatItem(
        icon: Icons.photo_library_outlined,
        label: '성장을 기록한 횟수',
        value: '0',
      ),
      _StatItem(
        icon: Icons.favorite_outline,
        label: '그로우브와 함께한 날수',
        value: '0',
      ),
      _StatItem(
        icon: Icons.eco_outlined,
        label: '가장 오래 함께한 식물',
        value: oldest?.name ?? '-',
        isName: true,
      ),
      _StatItem(
        icon: Icons.hourglass_empty_outlined,
        label: oldest != null ? '${oldest.name}과 함께한 날수' : '- 과 함께한 날수',
        value: plants.isEmpty ? '0' : '$daysWithOldest',
        isLarge: true,
      ),
    ];

    return Padding(
      padding: const EdgeInsets.all(20),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 1.0,
        ),
        itemCount: items.length,
        itemBuilder: (_, i) => _StatCard(item: items[i]),
      ),
    );
  }
}

class _StatsData {
  const _StatsData({
    required this.plants,
    required this.user,
    this.oldestPlant,
    required this.wateredCount,
  });

  final List<PlantModel> plants;
  final UserModel user;
  final PlantModel? oldestPlant;
  final int wateredCount;
}

class _StatItem {
  const _StatItem({
    required this.icon,
    required this.label,
    required this.value,
    this.isName = false,
    this.isLarge = false,
  });

  final IconData icon;
  final String label;
  final String value;
  final bool isName;
  final bool isLarge;
}

class _StatCard extends StatelessWidget {
  const _StatCard({required this.item});

  final _StatItem item;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: PlantItColors.paper,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(item.icon, size: 26, color: PlantItColors.text),
          const SizedBox(height: 10),
          Text(
            item.label,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 11,
              color: PlantItColors.muted,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            item.value,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: item.isLarge ? 18 : (item.isName ? 15 : 22),
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── 비밀번호 수정 다이얼로그 ──────────────────────────────────────────────────

class _ChangePasswordDialog extends StatefulWidget {
  const _ChangePasswordDialog();

  @override
  State<_ChangePasswordDialog> createState() => _ChangePasswordDialogState();
}

class _ChangePasswordDialogState extends State<_ChangePasswordDialog> {
  final _current = TextEditingController();
  final _newPw = TextEditingController();
  final _confirm = TextEditingController();
  bool _loading = false;
  bool _obscure1 = true, _obscure2 = true, _obscure3 = true;

  @override
  void dispose() {
    _current.dispose();
    _newPw.dispose();
    _confirm.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: const Color(0xFFF5F0E8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(22, 24, 22, 18),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '비밀번호 수정',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 18),
            _PwField(
              controller: _current,
              label: '현재 비밀번호',
              obscure: _obscure1,
              onToggle: () => setState(() => _obscure1 = !_obscure1),
            ),
            const SizedBox(height: 10),
            _PwField(
              controller: _newPw,
              label: '새 비밀번호',
              obscure: _obscure2,
              onToggle: () => setState(() => _obscure2 = !_obscure2),
            ),
            const SizedBox(height: 10),
            _PwField(
              controller: _confirm,
              label: '새 비밀번호 확인',
              obscure: _obscure3,
              onToggle: () => setState(() => _obscure3 = !_obscure3),
            ),
            const SizedBox(height: 22),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text(
                    '취소',
                    style: TextStyle(color: PlantItColors.muted),
                  ),
                ),
                const SizedBox(width: 8),
                TextButton(
                  onPressed: _loading ? null : _save,
                  child: _loading
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text(
                          '저장',
                          style: TextStyle(
                            color: PlantItColors.green,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _save() async {
    if (_newPw.text != _confirm.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('새 비밀번호가 일치하지 않아요.')),
      );
      return;
    }
    if (_newPw.text.length < 8) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('비밀번호는 8자 이상이어야 해요.')),
      );
      return;
    }
    setState(() => _loading = true);
    try {
      await ApiService.instance.changePassword(
        currentPassword: _current.text,
        newPassword: _newPw.text,
      );
      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('비밀번호가 변경되었어요.')),
        );
      }
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(error.toString())));
        setState(() => _loading = false);
      }
    }
  }
}

class _PwField extends StatelessWidget {
  const _PwField({
    required this.controller,
    required this.label,
    required this.obscure,
    required this.onToggle,
  });

  final TextEditingController controller;
  final String label;
  final bool obscure;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: PlantItColors.muted),
        ),
        TextField(
          controller: controller,
          obscureText: obscure,
          decoration: InputDecoration(
            hintText: '...',
            hintStyle: const TextStyle(color: PlantItColors.muted),
            suffixIcon: IconButton(
              onPressed: onToggle,
              icon: Icon(
                obscure
                    ? Icons.visibility_off_outlined
                    : Icons.visibility_outlined,
                color: PlantItColors.muted,
                size: 20,
              ),
            ),
            border: const UnderlineInputBorder(
              borderSide: BorderSide(color: PlantItColors.line),
            ),
            enabledBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: PlantItColors.line),
            ),
            contentPadding: const EdgeInsets.fromLTRB(0, 6, 0, 8),
          ),
        ),
      ],
    );
  }
}
