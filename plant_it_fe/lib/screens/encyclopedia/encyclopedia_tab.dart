part of '../app_screen.dart';

class EncyclopediaTab extends StatefulWidget {
  const EncyclopediaTab({super.key});

  @override
  State<EncyclopediaTab> createState() => _EncyclopediaTabState();
}

class _EncyclopediaTabState extends State<EncyclopediaTab> {
  final _searchController = TextEditingController();
  late Future<List<PlantCareGuideModel>> _guides =
      ApiService.instance.getGuides();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<PlantCareGuideModel>>(
      future: _guides,
      builder: (context, snapshot) {
        return ListView(
          padding: const EdgeInsets.fromLTRB(20, 46, 20, 116),
          children: [
            _MenuButton(onTap: () => Scaffold.of(context).openDrawer()),
            const SizedBox(height: 12),
            const Text(
              '식물 도감',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 16),
            // 검색 바 (둥근 스타일)
            Container(
              height: 46,
              decoration: BoxDecoration(
                color: PlantItColors.paper,
                borderRadius: BorderRadius.circular(23),
              ),
              clipBehavior: Clip.hardEdge,
              child: TextField(
                controller: _searchController,
                onSubmitted: (keyword) => setState(
                  () =>
                      _guides = ApiService.instance.getGuides(keyword: keyword),
                ),
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.search, size: 20),
                  hintText: '검색',
                  filled: false,
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
            const SizedBox(height: 20),
            if (snapshot.connectionState != ConnectionState.done)
              const _CenteredProgress()
            else if (snapshot.hasError)
              _ErrorState(
                message: snapshot.error.toString(),
                onRetry: () => setState(
                  () => _guides = ApiService.instance.getGuides(),
                ),
              )
            else if (snapshot.requireData.isEmpty)
              const _EmptyCard(
                title: '도감 데이터가 없어요',
                body: '관리자 페이지에서 식물도감을 등록하면 이곳에 표시됩니다.',
              )
            else
              for (final guide in snapshot.requireData)
                _EncyclopediaListItem(
                  guide: guide,
                  onTap: () => _openDetail(context, guide),
                ),
          ],
        );
      },
    );
  }

  void _openDetail(BuildContext context, PlantCareGuideModel guide) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => GuideDetailScreen(guideId: guide.id),
      ),
    );
  }
}

// ─── 도감 목록 아이템 ──────────────────────────────────────────────────────────

class _EncyclopediaListItem extends StatelessWidget {
  const _EncyclopediaListItem({required this.guide, required this.onTap});

  final PlantCareGuideModel guide;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: SizedBox(
                width: 68,
                height: 68,
                child: _PlantImage(url: guide.imageUrl),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                guide.speciesName,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── 도감 상세 화면 ────────────────────────────────────────────────────────────

class GuideDetailScreen extends StatefulWidget {
  const GuideDetailScreen({required this.guideId, super.key});

  final int guideId;

  @override
  State<GuideDetailScreen> createState() => _GuideDetailScreenState();
}

class _GuideDetailScreenState extends State<GuideDetailScreen> {
  late Future<PlantCareGuideModel> _guide;

  @override
  void initState() {
    super.initState();
    _guide = ApiService.instance.getGuide(widget.guideId);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<PlantCareGuideModel>(
      future: _guide,
      builder: (context, snapshot) {
        return Scaffold(
          extendBodyBehindAppBar: false,
          body: switch (snapshot.connectionState) {
            ConnectionState.done when snapshot.hasData =>
              _body(snapshot.requireData, context),
            ConnectionState.done => _ErrorState(
              message: snapshot.error.toString(),
              onRetry: () => setState(
                () => _guide = ApiService.instance.getGuide(widget.guideId),
              ),
            ),
            _ => const _CenteredProgress(),
          },
        );
      },
    );
  }

  Widget _body(PlantCareGuideModel guide, BuildContext context) {
    return ListView(
      padding: EdgeInsets.zero,
      children: [
        Stack(
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
              child: AspectRatio(
                aspectRatio: 1.2,
                child: _PlantImage(url: guide.imageUrl, fit: BoxFit.cover),
              ),
            ),
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.only(left: 8, top: 8),
                child: IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.arrow_back),
                  style: IconButton.styleFrom(backgroundColor: Colors.white70),
                ),
              ),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                guide.speciesName,
                style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 8),
              if ((guide.lifespan?.isNotEmpty ?? false) || (guide.size?.isNotEmpty ?? false))
                Row(
                  children: [
                    if (guide.lifespan?.isNotEmpty ?? false) ...[
                      const Icon(Icons.hourglass_empty_outlined, size: 14, color: PlantItColors.muted),
                      const SizedBox(width: 4),
                      Text(guide.lifespan!, style: const TextStyle(fontSize: 13, color: PlantItColors.muted)),
                      const SizedBox(width: 20),
                    ],
                    if (guide.size?.isNotEmpty ?? false) ...[
                      const Icon(Icons.height, size: 14, color: PlantItColors.muted),
                      const SizedBox(width: 4),
                      Text(guide.size!, style: const TextStyle(fontSize: 13, color: PlantItColors.muted)),
                    ],
                  ],
                ),
              if (guide.description?.isNotEmpty ?? false) ...[
                const SizedBox(height: 16),
                Text(
                  guide.description!,
                  style: const TextStyle(fontSize: 14, height: 1.75, color: PlantItColors.text),
                ),
              ],
              const SizedBox(height: 28),
              const Text(
                '관리 정보',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 14),
              _GuideInfoSection(
                icon: Icons.wb_sunny_outlined,
                label: '햇빛',
                value: guide.sunlight,
              ),
              _GuideInfoSection(
                icon: Icons.water_drop_outlined,
                label: '물주기',
                value: guide.watering,
              ),
              _GuideInfoSection(
                icon: Icons.eco_outlined,
                label: '비료',
                value: guide.fertilizer,
              ),
              _GuideInfoSection(
                icon: Icons.water_outlined,
                label: '습도',
                value: guide.humidity,
              ),
              _GuideInfoSection(
                icon: Icons.thermostat_outlined,
                label: '온도',
                value: guide.temperature,
              ),
              _GuideInfoSection(
                icon: Icons.warning_amber_outlined,
                label: '독성',
                value: guide.toxicity,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _GuideInfoSection extends StatelessWidget {
  const _GuideInfoSection({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String? value;

  @override
  Widget build(BuildContext context) {
    if (value == null || value!.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: PlantItColors.green),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: PlantItColors.text,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value!,
                  style: const TextStyle(
                    fontSize: 13,
                    height: 1.6,
                    color: PlantItColors.muted,
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
