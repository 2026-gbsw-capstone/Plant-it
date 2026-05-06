import 'package:flutter/material.dart';
import 'package:plant_it_fe/screens/shared/app_routes.dart';
import 'package:plant_it_fe/screens/shared/app_theme.dart';
import 'package:plant_it_fe/screens/shared/app_widgets.dart';
import 'package:plant_it_fe/screens/shared/mock_data.dart';

class PlantsScreen extends StatelessWidget {
  const PlantsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PrototypeScaffold(
      includeBottomSafeArea: false,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 36, 16, 120),
        children: [
          const Align(alignment: Alignment.centerLeft, child: MenuButton()),
          const SizedBox(height: 34),
          Row(
            children: [
              Text('내 식물', style: Theme.of(context).textTheme.headlineLarge),
              const Spacer(),
              RoundIconButton(
                onPressed: () =>
                    Navigator.pushNamed(context, AppRoutes.plantAdd),
                icon: const Icon(Icons.add, size: 28),
              ),
            ],
          ),
          const SizedBox(height: 30),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: demoPlants.length + 2,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 48,
              crossAxisSpacing: 16,
              childAspectRatio: 1,
            ),
            itemBuilder: (context, index) {
              if (index >= demoPlants.length) {
                return const _EmptyPlantTile();
              }
              final plant = demoPlants[index];
              return _PlantTile(plant: plant);
            },
          ),
        ],
      ),
    );
  }
}

class _PlantTile extends StatelessWidget {
  final DemoPlant plant;

  const _PlantTile({required this.plant});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () =>
          Navigator.pushNamed(context, AppRoutes.plantDetail, arguments: plant),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned.fill(child: PrototypeImage(asset: plant.imageAsset)),
          Positioned(
            right: 10,
            bottom: 10,
            child: Text(
              plant.model.name,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w900,
                shadows: [Shadow(color: Colors.black54, blurRadius: 6)],
              ),
            ),
          ),
          if (plant.needsWater)
            const Positioned(
              top: -15,
              left: 6,
              child: _CareBadge(iconName: 'water', color: AppColors.blue),
            ),
          if (plant.needsFertilizer)
            const Positioned(
              top: -15,
              left: 42,
              child: _CareBadge(
                iconName: 'calendar',
                color: AppColors.lightGreen,
              ),
            ),
        ],
      ),
    );
  }
}

class _CareBadge extends StatelessWidget {
  final String iconName;
  final Color color;

  const _CareBadge({required this.iconName, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Center(
        child: AssetIcon(name: iconName, color: Colors.white, size: 18),
      ),
    );
  }
}

class _EmptyPlantTile extends StatelessWidget {
  const _EmptyPlantTile();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const Positioned.fill(child: CheckerBox()),
        const Positioned(
          right: 10,
          bottom: 10,
          child: Text(
            '이름',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
      ],
    );
  }
}

class PlantDetailScreen extends StatelessWidget {
  final DemoPlant plant;

  const PlantDetailScreen({super.key, required this.plant});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PrototypeScaffold(
        includeBottomSafeArea: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 34, 16, 120),
          children: [
            Row(
              children: [
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const AssetIcon(name: 'back'),
                ),
                Expanded(
                  child: Text(
                    plant.model.name,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontFamily: 'twaySky',
                      fontSize: 24,
                    ),
                  ),
                ),
                const SizedBox(width: 48),
              ],
            ),
            const SizedBox(height: 18),
            Stack(
              children: [
                PrototypeImage(
                  asset: plant.imageAsset,
                  width: double.infinity,
                  height: 370,
                  borderRadius: BorderRadius.circular(24),
                ),
                Positioned(
                  top: 14,
                  right: 14,
                  child: Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.86),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Center(child: AssetIcon(name: 'heart')),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        plant.model.name,
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        plant.model.speciesName ?? '',
                        style: const TextStyle(
                          color: AppColors.subText,
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                ),
                RoundIconButton(
                  color: AppColors.blue,
                  size: 66,
                  icon: const AssetIcon(
                    name: 'water',
                    color: Colors.white,
                    size: 30,
                  ),
                  onPressed: () => showPlantSnack(context, '물주기 기록 더미 처리'),
                ),
              ],
            ),
            const SizedBox(height: 18),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _ActionPill(
                  label: '성장 갤러리',
                  icon: 'calendar',
                  selected: true,
                  onTap: () => Navigator.pushNamed(
                    context,
                    AppRoutes.plantGrowthGallery,
                    arguments: plant,
                  ),
                ),
                _ActionPill(
                  label: '질문',
                  icon: 'chat',
                  onTap: () =>
                      Navigator.pushNamed(context, AppRoutes.plantChat),
                ),
                _ActionPill(
                  label: '수정',
                  icon: 'edit',
                  onTap: () => _showEditDialog(context),
                ),
                _ActionPill(
                  label: '잠금',
                  icon: 'lock-closed',
                  onTap: () => _showSimpleDialog(context, '잠금 설정'),
                ),
                _ActionPill(
                  label: '삭제',
                  icon: 'trash',
                  onTap: () => _showSimpleDialog(context, '삭제하시겠습니까?'),
                ),
              ],
            ),
            const SizedBox(height: 24),
            _GuideSection(
              icon: 'water',
              title: '물',
              trailing: '00일 후 물주기',
              text:
                  '흙을 손가락으로 찔러봐서 완전히 건조한 상태일 때 물을 주세요. 봄과 여름에는 2주에 한 번, 가을과 겨울에는 6-8주에 한 번으로 줄입니다.',
            ),
            _GuideSection(
              icon: 'sun',
              title: '햇빛',
              text: '하루 4-6시간의 밝은 직사광선을 좋아합니다. 햇빛이 가장 잘 드는 창가 자리를 마련해 주세요.',
            ),
            _GuideSection(
              icon: 'temperature',
              title: '온도 & 습도',
              text: '18-30°C의 따뜻하고 건조한 환경을 선호합니다. 높은 습도는 피해 주세요.',
            ),
            _GuideSection(
              icon: 'fertilizer',
              title: '비료',
              text: '비료는 필수는 아니지만 봄과 여름에 한 번씩 주면 성장에 도움이 됩니다.',
            ),
            _GuideSection(
              icon: 'plant',
              title: '분갈이',
              text: '2-3년에 한 번, 봄철에 한 치수 큰 화분으로 옮겨 주세요.',
            ),
            _GuideSection(
              icon: 'alert',
              title: '주의사항',
              text: plant.model.memo ?? '과습을 피하고 통풍이 잘 되는 곳에 둬 주세요.',
            ),
            const SizedBox(height: 18),
            Container(
              height: 122,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(12),
              ),
              alignment: Alignment.topLeft,
              child: const Text('노트 작성', style: TextStyle(fontSize: 13)),
            ),
          ],
        ),
      ),
    );
  }

  void _showEditDialog(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('식물 편집'),
        content: const Text('이름, 물주기, 비료주기, 메모를 수정합니다.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('취소'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('저장'),
          ),
        ],
      ),
    );
  }

  void _showSimpleDialog(BuildContext context, String title) {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: const Text('API 연동 전 더미 액션입니다.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('확인'),
          ),
        ],
      ),
    );
  }
}

class _ActionPill extends StatelessWidget {
  final String label;
  final String icon;
  final bool selected;
  final VoidCallback onTap;

  const _ActionPill({
    required this.label,
    required this.icon,
    this.selected = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bg = selected ? AppColors.lightGreen : AppColors.surface;
    final fg = selected ? Colors.white : AppColors.subText;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            AssetIcon(name: icon, color: fg, size: 16),
            const SizedBox(width: 4),
            Text(label, style: TextStyle(color: fg, fontSize: 12)),
          ],
        ),
      ),
    );
  }
}

class _GuideSection extends StatelessWidget {
  final String icon;
  final String title;
  final String text;
  final String? trailing;

  const _GuideSection({
    required this.icon,
    required this.title,
    required this.text,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              AssetIcon(name: icon, size: 16, color: AppColors.subText),
              const SizedBox(width: 6),
              Text(
                title,
                style: const TextStyle(color: AppColors.subText, fontSize: 12),
              ),
              const Spacer(),
              if (trailing != null)
                Text(
                  trailing!,
                  style: const TextStyle(
                    color: AppColors.subText,
                    fontSize: 12,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 10),
          Text(text, style: Theme.of(context).textTheme.bodyLarge),
        ],
      ),
    );
  }
}

class PlantAddScreen extends StatelessWidget {
  const PlantAddScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('식물 추가'),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const AssetIcon(name: 'back'),
        ),
      ),
      body: PrototypeScaffold(
        includeBottomSafeArea: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 24),
          children: [
            const CheckerBox(
              width: double.infinity,
              height: 370,
              borderRadius: BorderRadius.all(Radius.circular(24)),
            ),
            const SizedBox(height: 20),
            InkWell(
              borderRadius: BorderRadius.circular(26),
              onTap: () =>
                  Navigator.pushNamed(context, AppRoutes.plantAddTable),
              child: Container(
                height: 56,
                padding: const EdgeInsets.symmetric(horizontal: 18),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(26),
                ),
                child: const Row(
                  children: [
                    Text('식물종', style: TextStyle(fontSize: 16)),
                    Spacer(),
                    AssetIcon(name: 'switch'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            const UnderlineTextField(label: '이름'),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('확인'),
            ),
          ],
        ),
      ),
    );
  }
}

class PlantAddTableScreen extends StatelessWidget {
  const PlantAddTableScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final names = [
      '식물종 이름',
      '동물종 이름',
      '용각볼 파리지옥',
      '사시그리아 데 알티모 모스 라 라테',
      '식물종 이름',
      '식물종 이름',
      '식물종 이름',
      '식물종 이름',
      '식물종 이름',
      '식물종 이름',
      '식물종 이름',
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('식물 추가'),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const AssetIcon(name: 'back'),
        ),
      ),
      body: PrototypeScaffold(
        includeBottomSafeArea: false,
        child: ListView.separated(
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 24),
          itemCount: names.length + 1,
          separatorBuilder: (_, _) => const SizedBox(height: 34),
          itemBuilder: (context, index) {
            if (index == 0) {
              return const TextField(
                decoration: InputDecoration(
                  hintText: '검색',
                  prefixIcon: Icon(Icons.search),
                ),
              );
            }
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                names[index - 1],
                style: const TextStyle(fontSize: 16),
              ),
            );
          },
        ),
      ),
    );
  }
}

class PlantGrowthGalleryScreen extends StatelessWidget {
  final DemoPlant plant;

  const PlantGrowthGalleryScreen({super.key, required this.plant});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('성장 갤러리'),
        actions: [
          RoundIconButton(
            size: 38,
            onPressed: () => Navigator.pushNamed(
              context,
              AppRoutes.plantGalleryAdd,
              arguments: plant,
            ),
            icon: const Icon(Icons.add),
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: PrototypeScaffold(
        includeBottomSafeArea: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
          children: demoDiaries
              .map(
                (diary) => Padding(
                  padding: const EdgeInsets.only(bottom: 18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      PrototypeImage(
                        asset: diary.imageUrl ?? plant.imageAsset,
                        width: double.infinity,
                        height: 300,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        '${diary.recordedAt.month}월 ${diary.recordedAt.day}일',
                        style: const TextStyle(fontWeight: FontWeight.w800),
                      ),
                      Text(diary.note ?? ''),
                    ],
                  ),
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}

class PlantGalleryAddScreen extends StatelessWidget {
  final DemoPlant plant;

  const PlantGalleryAddScreen({super.key, required this.plant});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('갤러리 추가')),
      body: PrototypeScaffold(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 20, 16, 24),
          children: [
            const CheckerBox(width: double.infinity, height: 370),
            const SizedBox(height: 20),
            const UnderlineTextField(label: '내용'),
            const SizedBox(height: 36),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('확인'),
            ),
          ],
        ),
      ),
    );
  }
}
