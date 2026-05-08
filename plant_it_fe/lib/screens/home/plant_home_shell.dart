part of '../app_screen.dart';

class PlantHomeShell extends StatefulWidget {
  const PlantHomeShell({super.key});

  @override
  State<PlantHomeShell> createState() => _PlantHomeShellState();
}

class _PlantHomeShellState extends State<PlantHomeShell> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  int _tab = 0;
  late Future<_HomeData> _homeData;

  @override
  void initState() {
    super.initState();
    _homeData = _load();
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
          ProfileTab(user: data.user),
        ];

        return Scaffold(
          key: _scaffoldKey,
          extendBody: true,
          drawer: _HomeDrawer(user: data.user, onSelectTab: _selectTab),
          body: SafeArea(bottom: false, child: screens[_tab]),
          bottomNavigationBar: _PlantBottomNav(
            selectedIndex: _tab,
            onChanged: (value) => setState(() => _tab = value),
          ),
        );
      },
    );
  }

  void _openMenu() => _scaffoldKey.currentState?.openDrawer();

  void _selectTab(int tab) {
    Navigator.pop(context);
    setState(() => _tab = tab);
  }

  Future<void> _openPlant(PlantModel plant) async {
    await context.push('/plants/${plant.id}');
    _refresh();
  }

  void _showAddPlantSheet() {
    showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const AddPlantSheet(),
    ).then((created) {
      if (created == true) _refresh();
    });
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
              fontWeight: FontWeight.w800,
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
              title: '우리집플스 프로젝트',
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
          Row(
            children: [
              const Text('오늘의 식물', style: TextStyle(fontSize: 13)),
              const Spacer(),
              IconButton(
                onPressed: onAdd,
                visualDensity: VisualDensity.compact,
                icon: const Icon(Icons.add, size: 20),
              ),
            ],
          ),
          const SizedBox(height: 10),
          if (plants.isEmpty)
            const SizedBox.shrink()
          else
            SizedBox(
              height: 86,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemBuilder: (_, index) => _MiniPlantCard(
                  plant: plants[index],
                  onTap: () => onOpenPlant(plants[index]),
                ),
                separatorBuilder: (_, _) => const SizedBox(width: 12),
                itemCount: plants.length,
              ),
            ),
        ],
      ),
    );
  }
}
