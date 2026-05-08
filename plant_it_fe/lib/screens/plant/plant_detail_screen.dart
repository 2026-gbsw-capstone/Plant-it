part of '../app_screen.dart';

class PlantDetailScreen extends StatefulWidget {
  const PlantDetailScreen({required this.plantId, super.key});

  final int plantId;

  @override
  State<PlantDetailScreen> createState() => _PlantDetailScreenState();
}

class _PlantDetailScreenState extends State<PlantDetailScreen> {
  int _segment = 0;
  late Future<_PlantDetailData> _data;

  @override
  void initState() {
    super.initState();
    _data = _load();
  }

  Future<_PlantDetailData> _load() async {
    final results = await Future.wait([
      ApiService.instance.getPlant(widget.plantId),
      ApiService.instance.getDiaries(widget.plantId),
    ]);
    return _PlantDetailData(
      plant: results[0] as PlantModel,
      diaries: results[1] as List<PlantDiaryModel>,
    );
  }

  void _refresh() => setState(() => _data = _load());

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<_PlantDetailData>(
      future: _data,
      builder: (context, snapshot) {
        return Scaffold(
          body: switch (snapshot.connectionState) {
            ConnectionState.done when snapshot.hasData => _detailBody(
              snapshot.requireData,
            ),
            ConnectionState.done => _ErrorState(
              message: snapshot.error.toString(),
              onRetry: _refresh,
            ),
            _ => const _CenteredProgress(),
          },
        );
      },
    );
  }

  Widget _detailBody(_PlantDetailData data) {
    final plant = data.plant;
    return RefreshIndicator(
      onRefresh: () async => _refresh(),
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 34, 16, 28),
        children: [
          Row(
            children: [
              IconButton(
                onPressed: () => context.pop(),
                icon: const Icon(Icons.arrow_back),
              ),
              Expanded(
                child: Text(
                  plant.name,
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              PopupMenuButton<String>(
                icon: const Icon(Icons.more_horiz),
                color: PlantItColors.paper,
                onSelected: (value) {
                  if (value == 'edit') _showEditSheet(plant);
                  if (value == 'delete') _showDeleteDialog();
                },
                itemBuilder: (_) => const [
                  PopupMenuItem(value: 'edit', child: Text('수정')),
                  PopupMenuItem(value: 'delete', child: Text('삭제')),
                ],
              ),
            ],
          ),
          const SizedBox(height: 14),
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: AspectRatio(
                  aspectRatio: 1.26,
                  child: _PlantImage(
                    url: plant.plantImageUrl,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Positioned(
                top: 10,
                right: 10,
                child: InkWell(
                  onTap: () => _showEditSheet(plant),
                  borderRadius: BorderRadius.circular(18),
                  child: Container(
                    width: 34,
                    height: 34,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.settings_outlined,
                      size: 18,
                      color: PlantItColors.ink,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Center(
            child: Text(
              plant.name,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
            ),
          ),
          const SizedBox(height: 6),
          Center(
            child: Text(
              plant.speciesLabel,
              style: const TextStyle(color: PlantItColors.muted, fontSize: 12),
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 8,
            runSpacing: 8,
            children: [
              _DetailChip(
                label: plant.healthStatus.label,
                color: plant.healthStatus == PlantHealthStatus.good
                    ? PlantItColors.green
                    : PlantItColors.alertText,
              ),
              _DetailChip(label: '물 ${plant.wateringLabel}'),
              _DetailChip(label: '주기 ${_cycleLabel(plant.wateringCycleDays)}'),
            ],
          ),
          const SizedBox(height: 18),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: PlantItColors.paper,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '식물 정보',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w900),
                ),
                const SizedBox(height: 12),
                _PlantInfoRow(label: '물 주기', value: plant.wateringLabel),
                _PlantInfoRow(
                  label: '물 주기 간격',
                  value: _cycleLabel(plant.wateringCycleDays),
                ),
                _PlantInfoRow(
                  label: '비료 주기',
                  value: _cycleLabel(plant.fertilizerCycleDays),
                ),
                _PlantInfoRow(label: '건강 상태', value: plant.healthStatus.label),
              ],
            ),
          ),
          if (plant.memo != null && plant.memo!.isNotEmpty) ...[
            const SizedBox(height: 14),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: PlantItColors.paper,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                plant.memo!,
                style: const TextStyle(fontSize: 12, height: 1.65),
              ),
            ),
          ],
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _PrimaryButton(
                  label: '물 주기',
                  onTap: () => _recordWater(plant.id),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _PrimaryButton(
                  label: '비료 주기',
                  onTap: () => _recordFertilizer(plant.id),
                ),
              ),
            ],
          ),
          const SizedBox(height: 22),
          _SegmentTabs(
            selected: _segment,
            labels: const ['성장 일지', '갤러리', 'AI 채팅'],
            onChanged: (value) => setState(() => _segment = value),
          ),
          const SizedBox(height: 16),
          if (_segment == 0)
            _DiaryList(
              diaries: data.diaries,
              onAdd: () => _showDiarySheet(plant.id),
            ),
          if (_segment == 1)
            _GalleryGrid(
              diaries: data.diaries,
              onAdd: () => _showDiarySheet(plant.id),
            ),
          if (_segment == 2) PlantChatPanel(plant: plant),
        ],
      ),
    );
  }

  Future<void> _recordWater(int plantId) async {
    await _runAction(
      () => ApiService.instance.waterPlant(plantId),
      '물주기 기록이 저장됐어요.',
    );
  }

  Future<void> _recordFertilizer(int plantId) async {
    await _runAction(
      () => ApiService.instance.fertilizePlant(plantId),
      '비료 기록이 저장됐어요.',
    );
  }

  Future<void> _runAction(
    Future<void> Function() action,
    String message,
  ) async {
    try {
      await action();
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(message)));
      _refresh();
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(error.toString())));
      }
    }
  }

  void _showEditSheet(PlantModel plant) {
    showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => AddPlantSheet(plant: plant),
    ).then((changed) {
      if (changed == true) _refresh();
    });
  }

  void _showDiarySheet(int plantId) {
    showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => DiarySheet(plantId: plantId),
    ).then((changed) {
      if (changed == true) _refresh();
    });
  }

  void _showDeleteDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('식물을 삭제할까요?'),
        content: const Text('삭제하면 성장 기록과 AI 분석 이력도 함께 정리됩니다.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('취소'),
          ),
          FilledButton(
            onPressed: () async {
              try {
                await ApiService.instance.deletePlant(widget.plantId);
                if (!mounted) return;
                Navigator.pop(context);
                Navigator.pop(context);
              } catch (error) {
                if (mounted) {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text(error.toString())));
                }
              }
            },
            child: const Text('삭제'),
          ),
        ],
      ),
    );
  }

  String _cycleLabel(int? days) => days == null ? '미정' : '$days일';
}

class _PlantDetailData {
  const _PlantDetailData({required this.plant, required this.diaries});

  final PlantModel plant;
  final List<PlantDiaryModel> diaries;
}

class _DetailChip extends StatelessWidget {
  const _DetailChip({required this.label, this.color = PlantItColors.green});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 24,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: color.withValues(alpha: .12),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child: Text(
          label,
          style: TextStyle(
            color: color,
            fontSize: 11,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    );
  }
}

class _PlantInfoRow extends StatelessWidget {
  const _PlantInfoRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 9),
      child: Row(
        children: [
          SizedBox(
            width: 92,
            child: Text(
              label,
              style: const TextStyle(color: PlantItColors.muted, fontSize: 12),
            ),
          ),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );
  }
}
