part of '../app_screen.dart';

class _OnboardingPage extends StatelessWidget {
  const _OnboardingPage({
    required this.image,
    required this.title,
    required this.body,
  });

  final String image;
  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Center(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(28),
              child: Image.asset(
                image,
                width: 260,
                height: 340,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        Text(
          title,
          style: const TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.w700,
            height: 1.25,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          body,
          style: const TextStyle(
            fontSize: 15,
            color: PlantItColors.muted,
            height: 1.6,
          ),
        ),
      ],
    );
  }
}

class _MenuButton extends StatelessWidget {
  const _MenuButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 32,
      height: 32,
      child: IconButton(
        padding: EdgeInsets.zero,
        alignment: Alignment.centerLeft,
        onPressed: onTap,
        icon: const Icon(Icons.menu, size: 26, color: PlantItColors.ink),
      ),
    );
  }
}

class _TopBar extends StatelessWidget {
  const _TopBar({required this.title, required this.onBack});

  final String title;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(onPressed: onBack, icon: const Icon(Icons.arrow_back)),
        Expanded(
          child: Text(
            title,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w900),
          ),
        ),
        const SizedBox(width: 48),
      ],
    );
  }
}

class _HomeDrawer extends StatelessWidget {
  const _HomeDrawer({required this.user, required this.onSelectTab});

  final UserModel user;
  final ValueChanged<int> onSelectTab;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: 292,
      backgroundColor: PlantItColors.cream,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 28, 20, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  _Avatar(url: user.profileImageUrl),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          user.nickname,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          user.email,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: PlantItColors.muted,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              _DrawerMenuItem(
                icon: 'assets/icons/home.svg',
                label: '홈',
                onTap: () => onSelectTab(0),
              ),
              _DrawerMenuItem(
                icon: 'assets/icons/plant.svg',
                label: '내 식물',
                onTap: () => onSelectTab(1),
              ),
              _DrawerMenuItem(
                icon: 'assets/icons/book.svg',
                label: '도감',
                onTap: () => onSelectTab(2),
              ),
              _DrawerMenuItem(
                icon: 'assets/icons/user.svg',
                label: '프로필',
                onTap: () => onSelectTab(3),
              ),
              _DrawerMenuItem(
                icon: 'assets/icons/gear.svg',
                label: '설정',
                onTap: () {
                  Navigator.pop(context);
                  context.push('/settings');
                },
              ),
              _DrawerMenuItem(
                icon: 'assets/icons/book.svg',
                label: '앱 정보',
                onTap: () {
                  Navigator.pop(context);
                  context.push('/app-info');
                },
              ),
              const Spacer(),
              _DrawerMenuItem(
                icon: 'assets/icons/back.svg',
                label: '닫기',
                onTap: () => Navigator.pop(context),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DrawerMenuItem extends StatelessWidget {
  const _DrawerMenuItem({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final String icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        height: 54,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Row(
          children: [
            _NavIcon(icon, color: PlantItColors.ink),
            const SizedBox(width: 14),
            Text(label, style: const TextStyle(fontWeight: FontWeight.w700)),
          ],
        ),
      ),
    );
  }
}

class _RoundIconButton extends StatelessWidget {
  const _RoundIconButton({required this.onPressed, required this.icon});

  final VoidCallback onPressed;
  final Widget icon;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 34,
      height: 34,
      child: IconButton.filled(
        padding: EdgeInsets.zero,
        onPressed: onPressed,
        icon: icon,
        style: IconButton.styleFrom(
          backgroundColor: PlantItColors.ink,
          foregroundColor: Colors.white,
        ),
      ),
    );
  }
}

class _AlertBanner extends StatelessWidget {
  const _AlertBanner({required this.plant, required this.onTap});

  final PlantModel plant;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        height: 38,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: PlantItColors.alert,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                '${plant.name}는 도움이 필요해요!',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: PlantItColors.alertText,
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            const Icon(
              Icons.arrow_forward,
              size: 16,
              color: PlantItColors.alertText,
            ),
          ],
        ),
      ),
    );
  }
}

class _TodayProjectCard extends StatelessWidget {
  const _TodayProjectCard({required this.plant, required this.onTap});

  final PlantModel plant;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        height: 174,
        padding: const EdgeInsets.fromLTRB(18, 18, 18, 14),
        decoration: BoxDecoration(
          color: PlantItColors.paper,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Spacer(),
                  const Text(
                    '우리집플스 프로젝트',
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800),
                  ),
                  const Spacer(),
                  const Text(
                    '오늘의 식물',
                    style: TextStyle(fontSize: 12, color: PlantItColors.muted),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    plant.wateringLabel,
                    style: const TextStyle(fontSize: 13),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            ClipOval(
              child: SizedBox(
                width: 104,
                height: 104,
                child: _PlantImage(url: plant.plantImageUrl),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MiniPlantCard extends StatelessWidget {
  const _MiniPlantCard({required this.plant, required this.onTap});

  final PlantModel plant;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: SizedBox(
        width: 86,
        height: 86,
        child: Stack(
          fit: StackFit.expand,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: _PlantImage(url: plant.plantImageUrl),
            ),
            Positioned(
              left: 8,
              top: 8,
              child: _StatusBadge(color: PlantItColors.alertText),
            ),
            Positioned(
              left: 8,
              right: 8,
              bottom: 8,
              child: Text(
                plant.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  shadows: [Shadow(color: Colors.black54, blurRadius: 8)],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PlantGridCard extends StatelessWidget {
  const _PlantGridCard({required this.plant, required this.onTap});

  final PlantModel plant;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Stack(
        fit: StackFit.expand,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: _PlantImage(url: plant.plantImageUrl),
          ),
          Positioned(
            left: 10,
            top: 10,
            child: _StatusBadge(
              color: plant.healthStatus == PlantHealthStatus.good
                  ? PlantItColors.green
                  : PlantItColors.alertText,
            ),
          ),
          Positioned(
            right: 10,
            top: 10,
            child: _StatusBadge(color: const Color(0xFF79A7C6)),
          ),
          Positioned(
            left: 10,
            right: 10,
            bottom: 12,
            child: Text(
              plant.name,
              textAlign: TextAlign.right,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w900,
                shadows: [Shadow(color: Colors.black87, blurRadius: 8)],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 18,
      height: 18,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      child: const Center(
        child: Icon(Icons.eco_outlined, size: 11, color: Colors.white),
      ),
    );
  }
}

class _CheckeredTile extends StatelessWidget {
  const _CheckeredTile();

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: CustomPaint(painter: _CheckeredPainter()),
    );
  }
}

class _CheckeredPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    const tile = 10.0;
    final light = Paint()..color = const Color(0xFFF4F0E8);
    final dark = Paint()..color = const Color(0xFFE4DDD3);
    for (double y = 0; y < size.height; y += tile) {
      for (double x = 0; x < size.width; x += tile) {
        final paint = ((x / tile).floor() + (y / tile).floor()).isEven
            ? light
            : dark;
        canvas.drawRect(Rect.fromLTWH(x, y, tile, tile), paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _DiaryList extends StatelessWidget {
  const _DiaryList({required this.diaries, required this.onAdd});

  final List<PlantDiaryModel> diaries;
  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    if (diaries.isEmpty) {
      return _EmptyCard(
        title: '성장 기록이 없어요',
        body: '사진과 메모로 오늘의 변화를 남겨보세요.',
        actionLabel: '기록 추가',
        onAction: onAdd,
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Align(
          alignment: Alignment.centerRight,
          child: TextButton.icon(
            onPressed: onAdd,
            icon: const Icon(Icons.add),
            label: const Text('기록 추가'),
          ),
        ),
        for (final diary in diaries) _DiaryTile(diary: diary),
      ],
    );
  }
}

class _DiaryTile extends StatelessWidget {
  const _DiaryTile({required this.diary});

  final PlantDiaryModel diary;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(16),
      decoration: _cardDecoration(radius: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _dateLabel(diary.recordedAt),
            style: const TextStyle(
              color: PlantItColors.green,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            diary.note?.isEmpty ?? true ? '메모 없음' : diary.note!,
            style: const TextStyle(height: 1.5),
          ),
          if (diary.aiHealthSummary != null &&
              diary.aiHealthSummary!.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              diary.aiHealthSummary!,
              style: const TextStyle(
                color: PlantItColors.muted,
                fontSize: 12,
                height: 1.5,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _GalleryGrid extends StatelessWidget {
  const _GalleryGrid({required this.diaries, required this.onAdd});

  final List<PlantDiaryModel> diaries;
  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    final images = diaries
        .where((diary) => diary.imageUrl?.isNotEmpty ?? false)
        .toList();
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: images.length + 1,
      itemBuilder: (_, index) {
        if (index == 0) {
          return InkWell(
            onTap: onAdd,
            borderRadius: BorderRadius.circular(18),
            child: Container(
              decoration: BoxDecoration(
                color: PlantItColors.greenSoft,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: PlantItColors.green.withValues(alpha: .18),
                ),
              ),
              child: const Icon(
                Icons.add_a_photo_outlined,
                color: PlantItColors.green,
              ),
            ),
          );
        }
        return ClipRRect(
          borderRadius: BorderRadius.circular(18),
          child: _PlantImage(
            url: images[index - 1].imageUrl,
            fit: BoxFit.cover,
          ),
        );
      },
    );
  }
}

class _EncyclopediaCard extends StatelessWidget {
  const _EncyclopediaCard({required this.guide});

  final PlantCareGuideModel guide;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: _cardDecoration(radius: 18),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: SizedBox(
              width: 82,
              height: 82,
              child: _PlantImage(url: guide.imageUrl),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  guide.speciesName,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  guide.description ?? '난이도 ${guide.difficulty}',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: PlantItColors.muted,
                    height: 1.45,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MenuTile extends StatelessWidget {
  const _MenuTile({required this.icon, required this.title, this.onTap});

  final String icon;
  final String title;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: _NavIcon(icon, color: PlantItColors.text),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
      trailing: const Icon(Icons.chevron_right),
      shape: const Border(bottom: BorderSide(color: PlantItColors.line)),
    );
  }
}

class _ChatBubble extends StatelessWidget {
  const _ChatBubble({required this.text, required this.mine});

  final String text;
  final bool mine;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: mine ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 260),
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
        decoration: BoxDecoration(
          color: mine ? PlantItColors.green : PlantItColors.greenSoft,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: mine ? Colors.white : PlantItColors.text,
            height: 1.4,
          ),
        ),
      ),
    );
  }
}

class _PrimaryButton extends StatelessWidget {
  const _PrimaryButton({
    required this.label,
    required this.onTap,
    this.expanded = false,
  });

  final String label;
  final VoidCallback? onTap;
  final bool expanded;

  @override
  Widget build(BuildContext context) {
    final button = FilledButton(
      onPressed: onTap,
      style: FilledButton.styleFrom(
        backgroundColor: PlantItColors.green,
        foregroundColor: Colors.white,
        minimumSize: Size(expanded ? double.infinity : 116, 48),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      ),
      child: Text(label, style: const TextStyle(fontWeight: FontWeight.w700)),
    );
    return expanded ? SizedBox(width: double.infinity, child: button) : button;
  }
}

class _SegmentTabs extends StatelessWidget {
  const _SegmentTabs({
    required this.selected,
    required this.labels,
    required this.onChanged,
  });

  final int selected;
  final List<String> labels;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 42,
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: PlantItColors.paper,
        borderRadius: BorderRadius.circular(21),
        border: Border.all(color: PlantItColors.line),
      ),
      child: Row(
        children: [
          for (var index = 0; index < labels.length; index++)
            Expanded(
              child: InkWell(
                onTap: () => onChanged(index),
                borderRadius: BorderRadius.circular(18),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 160),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: selected == index
                        ? PlantItColors.green
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Text(
                    labels[index],
                    style: TextStyle(
                      color: selected == index
                          ? Colors.white
                          : PlantItColors.ink,
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _EmptyCard extends StatelessWidget {
  const _EmptyCard({
    required this.title,
    required this.body,
    this.actionLabel,
    this.onAction,
  });

  final String title;
  final String body;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 8),
          Text(
            body,
            style: const TextStyle(color: PlantItColors.muted, height: 1.5),
          ),
          if (actionLabel != null && onAction != null) ...[
            const SizedBox(height: 16),
            _PrimaryButton(label: actionLabel!, onTap: onAction),
          ],
        ],
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  const _ErrorState({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: _EmptyCard(
          title: '데이터를 불러오지 못했어요',
          body: message,
          actionLabel: '다시 시도',
          onAction: onRetry,
        ),
      ),
    );
  }
}

class _CenteredProgress extends StatelessWidget {
  const _CenteredProgress();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(color: PlantItColors.green),
    );
  }
}

class _SheetFrame extends StatelessWidget {
  const _SheetFrame({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(
        20,
        12,
        20,
        MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      decoration: const BoxDecoration(
        color: PlantItColors.cream,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 42,
              height: 4,
              decoration: BoxDecoration(
                color: PlantItColors.line,
                borderRadius: BorderRadius.circular(99),
              ),
            ),
            const SizedBox(height: 22),
            child,
          ],
        ),
      ),
    );
  }
}

class _Dot extends StatelessWidget {
  const _Dot({required this.active});

  final bool active;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      width: active ? 22 : 8,
      height: 8,
      decoration: BoxDecoration(
        color: active ? PlantItColors.green : PlantItColors.line,
        borderRadius: BorderRadius.circular(99),
      ),
    );
  }
}

class _PlantBottomNav extends StatelessWidget {
  const _PlantBottomNav({required this.selectedIndex, required this.onChanged});

  final int selectedIndex;
  final ValueChanged<int> onChanged;

  static const _items = [
    ('assets/icons/home.svg', '홈'),
    ('assets/icons/plant.svg', '내 식물'),
    ('assets/icons/book.svg', '도감'),
    ('assets/icons/user.svg', 'MY'),
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      minimum: const EdgeInsets.fromLTRB(16, 0, 16, 18),
      child: Center(
        heightFactor: 1,
        child: Container(
          height: 58,
          constraints: const BoxConstraints(maxWidth: 330),
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: PlantItColors.paper,
            borderRadius: BorderRadius.circular(28),
            border: Border.all(color: PlantItColors.line),
            boxShadow: const [
              BoxShadow(
                color: Color(0x1A000000),
                blurRadius: 18,
                offset: Offset(0, 8),
              ),
            ],
          ),
          child: Row(
            children: [
              for (var index = 0; index < _items.length; index++)
                Expanded(
                  child: _PlantBottomNavItem(
                    icon: _items[index].$1,
                    label: _items[index].$2,
                    selected: index == selectedIndex,
                    onTap: () => onChanged(index),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PlantBottomNavItem extends StatelessWidget {
  const _PlantBottomNavItem({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final foreground = selected ? Colors.white : PlantItColors.ink;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(24),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        height: 50,
        decoration: BoxDecoration(
          color: selected ? PlantItColors.ink : Colors.transparent,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _NavIcon(icon, color: foreground),
            const SizedBox(height: 3),
            Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: foreground,
                fontSize: 10,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NavIcon extends StatelessWidget {
  const _NavIcon(this.asset, {this.color});

  final String asset;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      asset,
      width: 22,
      height: 22,
      colorFilter: color == null
          ? null
          : ColorFilter.mode(color!, BlendMode.srcIn),
    );
  }
}

class _PlantImage extends StatelessWidget {
  const _PlantImage({this.url, this.fit = BoxFit.cover});

  final String? url;
  final BoxFit fit;

  @override
  Widget build(BuildContext context) {
    final value = url?.trim();
    if (value != null && value.isNotEmpty) {
      return Image.network(
        value,
        fit: fit,
        errorBuilder: (_, _, _) => Image.asset(_fallbackPlantImage, fit: fit),
      );
    }
    return Image.asset(_fallbackPlantImage, fit: fit);
  }
}

class _Avatar extends StatelessWidget {
  const _Avatar({this.url});

  final String? url;

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: SizedBox(width: 58, height: 58, child: _PlantImage(url: url)),
    );
  }
}

BoxDecoration _cardDecoration({double radius = 20}) {
  return BoxDecoration(
    color: PlantItColors.paper,
    borderRadius: BorderRadius.circular(radius),
    border: Border.all(color: PlantItColors.line),
    boxShadow: const [
      BoxShadow(color: Color(0x0F000000), blurRadius: 16, offset: Offset(0, 8)),
    ],
  );
}

String _dateLabel(DateTime? date) {
  if (date == null) return '날짜 없음';
  return '${date.month}월 ${date.day}일';
}

String _timeGreeting(DateTime dateTime) {
  final hour = dateTime.hour;
  if (hour >= 5 && hour < 12) return '좋은 아침이에요';
  if (hour >= 12 && hour < 18) return '좋은 오후예요';
  if (hour >= 18 && hour < 22) return '좋은 저녁이에요';
  return '편안한 밤이에요';
}

bool _needsHelp(PlantModel plant) {
  if (plant.healthStatus != PlantHealthStatus.good) return true;
  final date = plant.nextWateringDate;
  if (date == null) return false;
  final today = DateTime.now();
  final diff = DateTime(
    date.year,
    date.month,
    date.day,
  ).difference(DateTime(today.year, today.month, today.day)).inDays;
  return diff <= 0;
}
