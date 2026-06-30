part of '../app_screen.dart';

// ─── 사이드바(메뉴 Drawer) ────────────────────────────────────────────────────
// 햄버거 메뉴를 누르면 풀스크린 네비게이션 대신 옆에서 슬라이드되는 Drawer로 뜬다.

class AppMenuDrawer extends StatelessWidget {
  const AppMenuDrawer({this.onReturn, super.key});

  /// Drawer 항목에서 다른 화면으로 갔다가 돌아왔을 때 셸을 새로고침하기 위한 콜백.
  final VoidCallback? onReturn;

  void _go(BuildContext context, String route) {
    Scaffold.of(context).closeDrawer();
    context.push(route).then((_) => onReturn?.call());
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: PlantItColors.cream,
      shape: const RoundedRectangleBorder(),
      child: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 46, 16, 40),
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: IconButton(
                onPressed: () => Scaffold.of(context).closeDrawer(),
                icon: const Icon(Icons.arrow_back),
                padding: EdgeInsets.zero,
              ),
            ),
            const SizedBox(height: 16),
            _ProfileMenuItem(
              icon: Icons.person_outline,
              label: '계정',
              onTap: () => _go(context, '/account'),
            ),
            _ProfileMenuItem(
              icon: Icons.notifications_outlined,
              label: '알림',
              onTap: () => _go(context, '/notifications'),
            ),
            _ProfileMenuItem(
              icon: Icons.bar_chart_outlined,
              label: '사용 통계',
              onTap: () => _go(context, '/stats'),
            ),
            _ProfileMenuItem(
              icon: Icons.info_outline,
              label: '앱 정보',
              onTap: () => _go(context, '/app-info'),
            ),
            const SizedBox(height: 40),
            _ProfileMenuItem(
              icon: Icons.settings_outlined,
              label: '설정',
              onTap: () => _go(context, '/settings'),
            ),
            _ProfileMenuItem(
              icon: Icons.logout,
              label: '로그아웃',
              onTap: () => _confirmLogout(context),
            ),
          ],
        ),
      ),
    );
  }
}

void _confirmLogout(BuildContext context) {
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
                    try {
                      await ApiService.instance.logout();
                    } catch (_) {}
                    await AuthService.instance.signOut();
                    if (context.mounted) context.go('/');
                  },
                  child: const Text(
                    '확인',
                    style: TextStyle(
                      color: Color(0xFFB94040),
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

  void _showLogoutDialog(BuildContext context) => _confirmLogout(context);
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
                // 프로필 사진 (탭하면 계정 정보 수정)
                GestureDetector(
                  onTap: () => _showEditProfileDialog(context, user),
                  child: Stack(
                    children: [
                      ClipOval(
                        child: SizedBox(
                          width: 96,
                          height: 96,
                          child: _PlantImage(url: user.profileImageUrl),
                        ),
                      ),
                      Positioned(
                        right: 0,
                        bottom: 0,
                        child: Container(
                          padding: const EdgeInsets.all(5),
                          decoration: const BoxDecoration(
                            color: PlantItColors.green,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.edit,
                            size: 14,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
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

  Future<void> _showEditProfileDialog(
    BuildContext context,
    UserModel user,
  ) async {
    final updated = await showDialog<bool>(
      context: context,
      builder: (_) => _ProfileEditDialog(user: user),
    );
    if (updated == true && mounted) {
      setState(() => _user = ApiService.instance.getMe());
    }
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

// ─── 계정 정보 수정 다이얼로그 ────────────────────────────────────────────────

class _ProfileEditDialog extends StatefulWidget {
  const _ProfileEditDialog({required this.user});

  final UserModel user;

  @override
  State<_ProfileEditDialog> createState() => _ProfileEditDialogState();
}

class _ProfileEditDialogState extends State<_ProfileEditDialog> {
  late final _nickname = TextEditingController(text: widget.user.nickname);
  late String _imagePath = widget.user.profileImageUrl ?? '';
  bool _saving = false;

  @override
  void dispose() {
    _nickname.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final path = await ImageUploadService.instance.pickPlantImage(
      ImageSource.gallery,
    );
    if (path != null && mounted) setState(() => _imagePath = path);
  }

  Future<void> _save() async {
    final nickname = _nickname.text.trim();
    if (nickname.isEmpty) {
      showSB(context, '유저네임을 입력해 주세요.');
      return;
    }
    if (!kNicknamePattern.hasMatch(nickname)) {
      showSB(context, kNicknameRuleMessage);
      return;
    }
    setState(() => _saving = true);
    try {
      final imageUrl = await ImageUploadService.instance.uploadIfLocalFile(
        _imagePath,
        type: 'profile',
      );
      await ApiService.instance.updateMe(
        nickname: nickname,
        profileImageUrl: imageUrl,
      );
      if (mounted) Navigator.pop(context, true);
    } catch (error) {
      if (mounted) {
        showSB(context, error.toString());
        setState(() => _saving = false);
      }
    }
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
              '계정 정보 수정',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 18),
            Center(
              child: GestureDetector(
                onTap: _saving ? null : _pickImage,
                child: Stack(
                  children: [
                    ClipOval(
                      child: SizedBox(
                        width: 80,
                        height: 80,
                        child: _PlantImage(url: _imagePath),
                      ),
                    ),
                    Positioned(
                      right: 0,
                      bottom: 0,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: PlantItColors.green,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.camera_alt,
                          size: 12,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              '이메일',
              style: TextStyle(fontSize: 12, color: PlantItColors.muted),
            ),
            const SizedBox(height: 4),
            Text(
              widget.user.email,
              style: const TextStyle(fontSize: 15),
            ),
            const SizedBox(height: 16),
            const Text(
              '유저네임',
              style: TextStyle(fontSize: 12, color: PlantItColors.muted),
            ),
            TextField(
              controller: _nickname,
              decoration: const InputDecoration(hintText: '...'),
            ),
            const SizedBox(height: 22),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: _saving ? null : () => Navigator.pop(context),
                  child: const Text(
                    '취소',
                    style: TextStyle(color: PlantItColors.muted),
                  ),
                ),
                const SizedBox(width: 8),
                TextButton(
                  onPressed: _saving ? null : _save,
                  child: _saving
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

    // 각 식물의 다이어리 수를 병렬로 조회
    final diaryFutures = plants.map(
      (p) => ApiService.instance.getDiaries(p.id).then((d) => d.length),
    );
    final diaryCounts = await Future.wait(diaryFutures);
    final totalDiaryCount = diaryCounts.fold<int>(0, (sum, c) => sum + c);

    // 가장 오래 함께한 식물 (registeredAt 기준)
    PlantModel? oldest;
    if (plants.isNotEmpty) {
      oldest = plants.reduce((a, b) {
        final aDate = a.registeredAt;
        final bDate = b.registeredAt;
        if (aDate == null) return b;
        if (bDate == null) return a;
        return aDate.isBefore(bDate) ? a : b;
      });
    }

    // 물을 준 횟수 (lastWateredAt이 있는 식물 수)
    final wateredCount = plants.where((p) => p.lastWateredAt != null).length;

    return _StatsData(
      plants: plants,
      user: user,
      oldestPlant: oldest,
      wateredCount: wateredCount,
      totalDiaryCount: totalDiaryCount,
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
    final user = data?.user;
    final oldest = data?.oldestPlant;

    final daysWithApp = user?.createdAt != null
        ? DateTime.now().difference(user!.createdAt!).inDays
        : 0;

    final daysWithOldest = oldest?.registeredAt != null
        ? DateTime.now().difference(oldest!.registeredAt!).inDays
        : 0;

    final items = [
      _StatItem(
        icon: Icons.eco_outlined,
        label: '키우는 식물 수',
        value: '${plants.length}',
      ),
      _StatItem(
        icon: Icons.water_drop_outlined,
        label: '물을 준 횟수',
        value: '${data?.wateredCount ?? 0}',
      ),
      _StatItem(
        icon: Icons.photo_library_outlined,
        label: '성장을 기록한 횟수',
        value: '${data?.totalDiaryCount ?? 0}',
      ),
      _StatItem(
        icon: Icons.favorite_outline,
        label: '그로우브와 함께한 날수',
        value: '$daysWithApp',
      ),
      _StatItem(
        icon: Icons.park_outlined,
        label: '가장 오래 함께한 식물',
        value: oldest?.name ?? '-',
        isName: true,
      ),
      _StatItem(
        icon: Icons.hourglass_empty_outlined,
        label: oldest != null ? '${oldest.name}과 함께한 날수' : '함께한 날수',
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
    required this.totalDiaryCount,
  });

  final List<PlantModel> plants;
  final UserModel user;
  final PlantModel? oldestPlant;
  final int wateredCount;
  final int totalDiaryCount;
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
      showSB(context, '새 비밀번호가 일치하지 않아요.');
      return;
    }
    if (_newPw.text.length < 8) {
      showSB(context, '비밀번호는 8자 이상이어야 해요.');
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
        showSB(context, '비밀번호가 변경되었어요.');
      }
    } catch (error) {
      if (mounted) {
        showSB(context, error.toString());
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
