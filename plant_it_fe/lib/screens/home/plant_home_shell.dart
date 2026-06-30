part of '../app_screen.dart';

class PlantHomeShell extends StatefulWidget {
  const PlantHomeShell({super.key});

  @override
  State<PlantHomeShell> createState() => _PlantHomeShellState();
}

class _PlantHomeShellState extends State<PlantHomeShell> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int _tab = 0;
  late Future<_HomeData> _homeData;

  @override
  void initState() {
    super.initState();
    _homeData = _load();
    PlantStore.instance.addListener(_refresh);
  }

  @override
  void dispose() {
    PlantStore.instance.removeListener(_refresh);
    super.dispose();
  }

  Future<_HomeData> _load() async {
    final results = await Future.wait([
      ApiService.instance.getMe(),
      ApiService.instance.getPlants(),
    ]);
    return _HomeData(
      user: results[0] as UserModel,
      plants: results[1] as List<PlantModel>,
    );
  }

  void _refresh() {
    setState(() => _homeData = _load());
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<_HomeData>(
      future: _homeData,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Scaffold(body: _CenteredProgress());
        }
        if (snapshot.hasError) {
          return Scaffold(
            body: _ErrorState(
              message: snapshot.error.toString(),
              onRetry: _refresh,
            ),
          );
        }
        final data = snapshot.requireData;
        final screens = [
          HomeTab(
            user: data.user,
            plants: data.plants,
            onOpenPlant: _openPlant,
            onAdd: _showAddPlantSheet,
            onRefresh: _refresh,
            onMenu: _openMenu,
          ),
          PlantsTab(
            plants: data.plants,
            onOpenPlant: _openPlant,
            onAdd: _showAddPlantSheet,
            onRefresh: _refresh,
            onMenu: _openMenu,
          ),
          const EncyclopediaTab(),
        ];

        return Scaffold(
          key: _scaffoldKey,
          extendBody: true,
          drawer: AppMenuDrawer(onReturn: _refresh),
          body: SafeArea(bottom: false, child: screens[_tab]),
          bottomNavigationBar: _PlantBottomNav(
            selectedIndex: _tab,
            onChanged: (value) => setState(() => _tab = value),
          ),
        );
      },
    );
  }

  void _openMenu() {
    _scaffoldKey.currentState?.openDrawer();
  }

  Future<void> _openPlant(PlantModel plant) async {
    await context.push('/plants/${plant.id}');
    _refresh();
  }

  Future<void> _showAddPlantSheet() async {
    // 피커 시트 결과: 경로 = 사진 선택, '' = 사진 없이 등록, null = 취소
    final result = await showModalBottomSheet<String?>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const AddPlantPhotoPickerSheet(),
    );
    if (result == null || !mounted) return;
    final imagePath = result.isEmpty ? null : result;
    await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (_) => AddPlantSheet(initialImagePath: imagePath),
      ),
    );
    // 등록 성공 시 PlantStore.notify()가 자동 새로고침하지만, 안전하게 한 번 더.
    if (mounted) _refresh();
  }
}

class _HomeData {
  const _HomeData({required this.user, required this.plants});

  final UserModel user;
  final List<PlantModel> plants;
}

class HomeTab extends StatelessWidget {
  const HomeTab({
    required this.user,
    required this.plants,
    required this.onOpenPlant,
    required this.onAdd,
    required this.onRefresh,
    required this.onMenu,
    super.key,
  });

  final UserModel user;
  final List<PlantModel> plants;
  final ValueChanged<PlantModel> onOpenPlant;
  final VoidCallback onAdd;
  final VoidCallback onRefresh;
  final VoidCallback onMenu;

  @override
  Widget build(BuildContext context) {
    final nextPlants = [...plants]
      ..sort((a, b) {
        final left = a.nextWateringDate ?? DateTime(2999);
        final right = b.nextWateringDate ?? DateTime(2999);
        return left.compareTo(right);
      });
    final helpPlant = plants.where(_needsHelp).firstOrNull;
    final greeting = _timeGreeting(DateTime.now());

    return RefreshIndicator(
      onRefresh: () async => onRefresh(),
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 46, 16, 116),
        children: [
          _MenuButton(onTap: onMenu),
          const SizedBox(height: 20),
          Text(
            '$greeting,\n${user.nickname}님',
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              height: 1.35,
            ),
          ),
          const SizedBox(height: 22),
          if (helpPlant != null) ...[
            _AlertBanner(plant: helpPlant, onTap: () => onOpenPlant(helpPlant)),
            const SizedBox(height: 18),
          ],
          if (nextPlants.isEmpty)
            _EmptyCard(
              title: '우리집 풀숲 프로젝트',
              body: '오늘의 식물을 등록하면 이곳에 가장 먼저 보여드릴게요.',
              actionLabel: '식물 등록',
              onAction: onAdd,
            )
          else
            _TodayProjectCard(
              plant: nextPlants.first,
              onTap: () => onOpenPlant(nextPlants.first),
            ),
          const SizedBox(height: 24),
          const Text(
            '물주기가 필요한 식물',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 12),
          if (plants.isEmpty)
            const SizedBox.shrink()
          else
            Builder(builder: (_) {
              final now = DateTime.now();
              final today = DateTime(now.year, now.month, now.day);
              final needsWater = plants.where((p) {
                if (p.nextWateringDate == null) return false;
                final d = p.nextWateringDate!;
                return DateTime(d.year, d.month, d.day).compareTo(today) <= 0;
              }).toList();
              if (needsWater.isEmpty) {
                return const Padding(
                  padding: EdgeInsets.symmetric(vertical: 12),
                  child: Text(
                    '물주기가 필요한 식물이 없어요 🌿',
                    style: TextStyle(color: PlantItColors.muted, fontSize: 13),
                  ),
                );
              }
              return SizedBox(
                height: 92,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: needsWater.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 10),
                  itemBuilder: (_, index) => _MiniPlantCard(
                    plant: needsWater[index],
                    onTap: () => onOpenPlant(needsWater[index]),
                  ),
                ),
              );
            }),
        ],
      ),
    );
  }
}
