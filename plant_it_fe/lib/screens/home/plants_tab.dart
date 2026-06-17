part of '../app_screen.dart';

class PlantsTab extends StatefulWidget {
  const PlantsTab({
    required this.plants,
    required this.onOpenPlant,
    required this.onAdd,
    required this.onRefresh,
    required this.onMenu,
    super.key,
  });

  final List<PlantModel> plants;
  final ValueChanged<PlantModel> onOpenPlant;
  final VoidCallback onAdd;
  final VoidCallback onRefresh;
  final VoidCallback onMenu;

  @override
  State<PlantsTab> createState() => _PlantsTabState();
}

class _PlantsTabState extends State<PlantsTab> {
  String _keyword = '';

  @override
  Widget build(BuildContext context) {
    final plants = widget.plants
        .where(
          (plant) =>
              plant.name.contains(_keyword) ||
              plant.speciesLabel.contains(_keyword),
        )
        .toList();
    return RefreshIndicator(
      onRefresh: () async => widget.onRefresh(),
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 46, 16, 116),
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _MenuButton(onTap: widget.onMenu),
              const Spacer(),
              _RoundIconButton(
                onPressed: widget.onAdd,
                icon: const Icon(Icons.add),
              ),
            ],
          ),
          const SizedBox(height: 18),
          const Text(
            '내 식물',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 22),
          TextField(
            onChanged: (value) => setState(() => _keyword = value),
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.search),
              hintText: '식물 이름 검색',
            ),
          ),
          const SizedBox(height: 18),
          if (plants.isEmpty)
            _EmptyCard(
              title: '표시할 식물이 없어요',
              body: '검색어를 바꾸거나 새 식물을 등록해 주세요.',
              actionLabel: '식물 등록',
              onAction: widget.onAdd,
            )
          else
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: .93,
              ),
              itemCount: plants.length,
              itemBuilder: (context, index) {
                final plant = plants[index];
                return _PlantGridCard(
                  plant: plant,
                  onTap: () => widget.onOpenPlant(plant),
                );
              },
            ),
        ],
      ),
    );
  }
}
