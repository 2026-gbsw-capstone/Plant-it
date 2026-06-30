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
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
          ),
        ),
        const SizedBox(width: 48),
      ],
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
                  fontWeight: FontWeight.w700,
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
                  Text(
                    plant.name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    plant.speciesLabel,
                    style: const TextStyle(
                      fontSize: 12,
                      color: PlantItColors.muted,
                    ),
                  ),
                  const Spacer(),
                  Row(
                    children: [
                      const Text(
                        '오늘의 식물',
                        style: TextStyle(
                          fontSize: 12,
                          color: PlantItColors.muted,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        plant.wateringLabel,
                        style: const TextStyle(fontSize: 12),
                      ),
                    ],
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
                  fontWeight: FontWeight.w700,
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
                fontWeight: FontWeight.w700,
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

class _ImagePickerPanel extends StatelessWidget {
  const _ImagePickerPanel({
    required this.imagePath,
    required this.emptyLabel,
    required this.onCamera,
    required this.onGallery,
    required this.onFile,
    required this.onClear,
    this.height = 188,
  });

  final String imagePath;
  final String emptyLabel;
  final VoidCallback onCamera;
  final VoidCallback onGallery;
  final VoidCallback onFile;
  final VoidCallback? onClear;
  final double height;

  @override
  Widget build(BuildContext context) {
    final hasImage = imagePath.trim().isNotEmpty;
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: PlantItColors.paper,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: PlantItColors.line),
      ),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: SizedBox(
              height: height,
              width: double.infinity,
              child: hasImage
                  ? _PlantImage(url: imagePath)
                  : Stack(
                      fit: StackFit.expand,
                      children: [
                        const _CheckeredTile(),
                        Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.add_a_photo_outlined,
                                color: PlantItColors.green,
                                size: 30,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                emptyLabel,
                                style: const TextStyle(
                                  color: PlantItColors.muted,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: _PickerActionButton(
                  icon: Icons.photo_camera_outlined,
                  label: '카메라',
                  onTap: onCamera,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _PickerActionButton(
                  icon: Icons.photo_library_outlined,
                  label: '앨범',
                  onTap: onGallery,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _PickerActionButton(
                  icon: Icons.folder_open_outlined,
                  label: '파일',
                  onTap: onFile,
                ),
              ),
              if (onClear != null) ...[
                const SizedBox(width: 8),
                _SquareIconButton(icon: Icons.close, onTap: onClear!),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

class _PickerActionButton extends StatelessWidget {
  const _PickerActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: onTap,
      icon: Icon(icon, size: 18),
      label: Text(label),
      style: OutlinedButton.styleFrom(
        foregroundColor: PlantItColors.green,
        side: const BorderSide(color: PlantItColors.line),
        minimumSize: const Size(0, 44),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        textStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
      ),
    );
  }
}

class _SquareIconButton extends StatelessWidget {
  const _SquareIconButton({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 44,
      height: 44,
      child: IconButton.outlined(
        onPressed: onTap,
        icon: Icon(icon, size: 18),
        color: PlantItColors.muted,
        style: IconButton.styleFrom(
          side: const BorderSide(color: PlantItColors.line),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
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
                  guide.description ?? guide.watering ?? guide.sunlight ?? '',
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
  const _MenuTile({required this.icon, required this.title, this.onTap, this.titleColor});

  final String icon;
  final String title;
  final VoidCallback? onTap;
  final Color? titleColor;

  @override
  Widget build(BuildContext context) {
    final color = titleColor ?? PlantItColors.text;
    return ListTile(
      onTap: onTap,
      leading: _NavIcon(icon, color: color),
      title: Text(title, style: TextStyle(fontWeight: FontWeight.w500, color: color)),
      trailing: Icon(Icons.chevron_right, color: color),
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
        minimumSize: Size(expanded ? double.infinity : 124, 52),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(26)),
        elevation: 0,
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w700,
          letterSpacing: 0,
        ),
      ),
    );
    return expanded ? SizedBox(width: double.infinity, child: button) : button;
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
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      minimum: const EdgeInsets.fromLTRB(20, 0, 20, 16),
      child: Center(
        heightFactor: 1,
        child: Container(
          height: 58,
          constraints: const BoxConstraints(maxWidth: 330),
          padding: const EdgeInsets.all(5),
          decoration: BoxDecoration(
            color: PlantItColors.paper,
            borderRadius: BorderRadius.circular(29),
            border: Border.all(color: PlantItColors.line),
            boxShadow: const [
              BoxShadow(
                color: Color(0x12000000),
                blurRadius: 18,
                offset: Offset(0, 7),
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
        duration: const Duration(milliseconds: 200),
        height: 48,
        decoration: BoxDecoration(
          color: selected ? PlantItColors.ink : Colors.transparent,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _NavIcon(icon, color: foreground),
            const SizedBox(height: 2),
            Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: foreground,
                fontSize: 10,
                fontWeight: FontWeight.w700,
                letterSpacing: 0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NavIcon extends StatelessWidget {
  const _NavIcon(this.asset, {this.color, this.size = 24});

  final String asset;
  final Color? color;
  final double size;

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      asset,
      width: size,
      height: size,
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
      final uri = Uri.tryParse(value);
      final isRemote =
          uri?.hasScheme == true &&
          (uri!.scheme == 'http' || uri.scheme == 'https');
      if (!isRemote) {
        return Image.file(
          File(value),
          fit: fit,
          errorBuilder: (_, _, _) => Image.asset(_fallbackPlantImage, fit: fit),
        );
      }
      return Image.network(
        value,
        fit: fit,
        errorBuilder: (_, _, _) => Image.asset(_fallbackPlantImage, fit: fit),
      );
    }
    return Image.asset(_fallbackPlantImage, fit: fit);
  }
}

// 백엔드(ValidationPatterns)와 동일한 입력 규칙. 이모지·공백·기타 특수문자를 막는다.
final RegExp kEmailPattern = RegExp(r'^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$');
final RegExp kPasswordPattern = RegExp(r'^[A-Za-z0-9!@#$%^&*()_+\-=]+$');
final RegExp kNicknamePattern = RegExp(r'^[가-힣a-zA-Z0-9_]{2,20}$');

const kPasswordRuleMessage = '비밀번호는 영문, 숫자, 일부 특수문자(!@#\$%^&*()_+-=)만 사용할 수 있어요.';
const kNicknameRuleMessage = '유저네임은 한글, 영문, 숫자, 밑줄(_)만 사용할 수 있고 2~20자여야 해요.';

/// 스낵바를 표시하기 전에 기존에 떠 있는 스낵바를 모두 제거한다.
/// 버튼 연타 시 스낵바가 누적되어 장시간 노출되는 문제를 막는다.
void showSB(BuildContext context, String message) {
  if (message.trim().isEmpty) return;
  ScaffoldMessenger.of(context)
    ..clearSnackBars()
    ..showSnackBar(SnackBar(content: Text(message)));
}

BoxDecoration _cardDecoration({double radius = 24}) {
  return BoxDecoration(
    color: PlantItColors.paper,
    borderRadius: BorderRadius.circular(radius),
    border: Border.all(color: PlantItColors.line, width: 1.2),
    boxShadow: const [
      BoxShadow(
        color: Color(0x0D000000),
        blurRadius: 24,
        offset: Offset(0, 12),
      ),
    ],
  );
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

class _ConfirmThenPasswordDialog extends StatefulWidget {
  const _ConfirmThenPasswordDialog({
    required this.title,
    required this.confirmMessage,
    required this.passwordMessage,
    required this.actionLabel,
    required this.actionColor,
    required this.onConfirm,
    required this.onSuccess,
  });

  final String title;
  final String confirmMessage;
  final String passwordMessage;
  final String actionLabel;
  final Color actionColor;
  final Future<void> Function(String password) onConfirm;
  final void Function(BuildContext context) onSuccess;

  @override
  State<_ConfirmThenPasswordDialog> createState() =>
      _ConfirmThenPasswordDialogState();
}

class _ConfirmThenPasswordDialogState
    extends State<_ConfirmThenPasswordDialog> {
  bool _step2 = false;
  bool _loading = false;
  bool _obscure = true;
  final _pw = TextEditingController();

  @override
  void dispose() {
    _pw.dispose();
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
            Text(
              widget.title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 14),
            Text(
              _step2 ? widget.passwordMessage : widget.confirmMessage,
              style: const TextStyle(fontSize: 14, height: 1.5),
            ),
            if (_step2) ...[
              const SizedBox(height: 14),
              const Text(
                '비밀번호',
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 6),
              TextField(
                controller: _pw,
                obscureText: _obscure,
                autofocus: true,
                decoration: InputDecoration(
                  hintText: '...',
                  suffixIcon: IconButton(
                    onPressed: () => setState(() => _obscure = !_obscure),
                    icon: Icon(
                      _obscure
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      color: PlantItColors.muted,
                    ),
                  ),
                ),
              ),
            ],
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
                  onPressed: _loading ? null : _onAction,
                  child: _loading
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Text(
                          widget.actionLabel,
                          style: TextStyle(
                            color: widget.actionColor,
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

  Future<void> _onAction() async {
    if (!_step2) {
      setState(() => _step2 = true);
      return;
    }
    final password = _pw.text.trim();
    if (password.isEmpty) return;

    setState(() => _loading = true);
    try {
      await widget.onConfirm(password);
      if (mounted) widget.onSuccess(context);
    } catch (error) {
      if (mounted) {
        showSB(context, error.toString());
        setState(() => _loading = false);
      }
    }
  }
}
