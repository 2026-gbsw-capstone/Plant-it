import 'package:flutter/material.dart';
import 'package:plant_it_fe/screens/encyclopedia/encyclopedia_screens.dart';
import 'package:plant_it_fe/screens/plant/plant_screens.dart';
import 'package:plant_it_fe/screens/shared/app_routes.dart';
import 'package:plant_it_fe/screens/shared/app_theme.dart';
import 'package:plant_it_fe/screens/shared/app_widgets.dart';
import 'package:plant_it_fe/screens/shared/mock_data.dart';

class MainShellScreen extends StatefulWidget {
  const MainShellScreen({super.key});

  @override
  State<MainShellScreen> createState() => _MainShellScreenState();
}

class _MainShellScreenState extends State<MainShellScreen> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    final screens = [
      HomeTab(onOpenPlants: () => setState(() => _index = 1)),
      const PlantsScreen(),
      const EncyclopediaScreen(),
    ];

    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(child: screens[_index]),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: PrototypeBottomNav(
              index: _index,
              onChanged: (value) => setState(() => _index = value),
            ),
          ),
        ],
      ),
    );
  }
}

class HomeTab extends StatelessWidget {
  final VoidCallback onOpenPlants;

  const HomeTab({super.key, required this.onOpenPlants});

  @override
  Widget build(BuildContext context) {
    final carePlants = demoPlants.where((plant) => plant.needsWater).toList();
    final visible = carePlants.isEmpty
        ? demoPlants.take(3).toList()
        : carePlants;

    return PrototypeScaffold(
      includeBottomSafeArea: false,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 36, 16, 120),
        children: [
          const Align(alignment: Alignment.centerLeft, child: MenuButton()),
          const SizedBox(height: 26),
          InkWell(
            borderRadius: BorderRadius.circular(24),
            onTap: () => Navigator.pushNamed(context, AppRoutes.plantChat),
            child: Container(
              height: 61,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: const Color(0xFFF5DFDC),
                borderRadius: BorderRadius.circular(28),
              ),
              child: const Row(
                children: [
                  Text(
                    '몬스테라는 도움이 필요해요!',
                    style: TextStyle(
                      color: AppColors.red,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  Spacer(),
                  Icon(Icons.arrow_forward_rounded, color: AppColors.red),
                ],
              ),
            ),
          ),
          const SizedBox(height: 36),
          Text(
            '좋은 아침이에요,\n${demoUser.nickname}님',
            style: Theme.of(
              context,
            ).textTheme.headlineMedium?.copyWith(fontSize: 30, height: 1.45),
          ),
          const SizedBox(height: 38),
          const Text(
            '물주기가 필요한 식물',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 14),
          SizedBox(
            height: 145,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: 3,
              separatorBuilder: (_, _) => const SizedBox(width: 16),
              itemBuilder: (context, index) {
                if (index >= visible.length) {
                  return const CheckerBox(width: 144, height: 144);
                }
                final plant = visible[index];
                return GestureDetector(
                  onTap: () => Navigator.pushNamed(
                    context,
                    AppRoutes.plantDetail,
                    arguments: plant,
                  ),
                  child: PrototypeImage(
                    asset: plant.imageAsset,
                    width: 144,
                    height: 144,
                    borderRadius: BorderRadius.circular(24),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 140),
        ],
      ),
    );
  }
}
