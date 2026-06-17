part of '../app_screen.dart';

class PlantDetailScreen extends StatefulWidget {
  const PlantDetailScreen({required this.plantId, super.key});

  final int plantId;

  @override
  State<PlantDetailScreen> createState() => _PlantDetailScreenState();
}

class _PlantDetailScreenState extends State<PlantDetailScreen> {
  late Future<_PlantDetailData> _data;

  @override
  void initState() {
    super.initState();
    _data = _load();
  }

  Future<_PlantDetailData> _load() async {
    final plant = await ApiService.instance.getPlant(widget.plantId);
    PlantCareGuideModel? guide;
    if ((plant.speciesName ?? '').isNotEmpty) {
      try {
        final guides = await ApiService.instance.getGuides(
          keyword: plant.speciesName,
        );
        if (guides.isNotEmpty) {
          final matched = guides.firstWhere(
            (g) =>
                g.speciesName.toLowerCase() ==
                (plant.speciesName ?? '').toLowerCase(),
            orElse: () => guides.first,
          );
          guide = await ApiService.instance.getGuide(matched.id);
        }
      } catch (_) {}
    }
    return _PlantDetailData(plant: plant, guide: guide);
  }

  void _refresh() => setState(() => _data = _load());

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<_PlantDetailData>(
      future: _data,
      builder: (context, snapshot) {
        return Scaffold(
          body: switch (snapshot.connectionState) {
            ConnectionState.done when snapshot.hasData =>
              _body(snapshot.requireData),
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

  Widget _body(_PlantDetailData data) {
    final plant = data.plant;
    final guide = data.guide;
    return RefreshIndicator(
      onRefresh: () async => _refresh(),
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          // Top image
          Stack(
            children: [
              GestureDetector(
                onTap: () => _showChangePhotoSheet(plant),
                child: AspectRatio(
                  aspectRatio: 1.0,
                  child: _PlantImage(url: plant.plantImageUrl, fit: BoxFit.cover),
                ),
              ),
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () => context.pop(),
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
                        style: IconButton.styleFrom(
                          backgroundColor: Colors.black26,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          plant.name,
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      // heart placeholder
                      Container(
                        width: 40,
                        height: 40,
                        decoration: const BoxDecoration(
                          color: Colors.black26,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.favorite_border,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          // Name + species + water button
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 18, 20, 0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        plant.name,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        plant.speciesLabel,
                        style: const TextStyle(
                          color: PlantItColors.muted,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () => _recordWater(plant.id),
                  child: Container(
                    width: 48,
                    height: 48,
                    decoration: const BoxDecoration(
                      color: Color(0xFF4F86D8),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.water_drop_outlined,
                      color: Colors.white,
                      size: 22,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 6),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              plant.wateringLabel == '미정'
                  ? '물주기 미정'
                  : '${plant.wateringLabel} 물주기',
              style: const TextStyle(
                fontSize: 12,
                color: PlantItColors.muted,
              ),
            ),
          ),
          const SizedBox(height: 18),
          // Action row: 성장 갤러리 | 질문 | 수정 | 잠금 | 삭제
          Container(
            padding: const EdgeInsets.symmetric(vertical: 10),
            decoration: const BoxDecoration(
              border: Border.symmetric(
                horizontal: BorderSide(color: PlantItColors.line),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _ActionButton(
                  icon: 'assets/icons/calendar.svg',
                  label: '성장 갤러리',
                  onTap: () =>
                      context.push('/plants/${plant.id}/gallery'),
                ),
                _ActionButton(
                  icon: 'assets/icons/chat.svg',
                  label: '질문',
                  onTap: () =>
                      context.push('/plants/${plant.id}/chat'),
                ),
                _ActionButton(
                  icon: 'assets/icons/edit.svg',
                  label: '수정',
                  onTap: () => _showSimpleEditDialog(plant),
                ),
                _ActionButton(
                  icon: 'assets/icons/lock-closed.svg',
                  label: '잠금',
                  onTap: () => _showLockDialog(plant),
                ),
                _ActionButton(
                  icon: 'assets/icons/trash.svg',
                  label: '삭제',
                  onTap: () => _showDeleteDialog(),
                  color: const Color(0xFFB94040),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          // Care guide info
          if (guide != null) ...[
            _GuideSectionCard(guide: guide),
            const SizedBox(height: 20),
          ] else if ((plant.wateringCycleDays != null ||
              plant.fertilizerCycleDays != null)) ...[
            _BasicCareCard(plant: plant),
            const SizedBox(height: 20),
          ],
          // Note
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '노트',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: PlantItColors.paper,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: PlantItColors.line),
                  ),
                  child: Text(
                    plant.memo?.trim().isEmpty ?? true
                        ? '노트 작성'
                        : plant.memo!,
                    style: TextStyle(
                      fontSize: 13,
                      color: plant.memo?.trim().isEmpty ?? true
                          ? PlantItColors.muted
                          : PlantItColors.text,
                      height: 1.55,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _recordWater(int plantId) async {
    try {
      await ApiService.instance.waterPlant(plantId);
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('물주기 기록이 저장됐어요.')));
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

  // Figma: 간단 수정 다이얼로그 (이름만)
  void _showSimpleEditDialog(PlantModel plant) {
    showDialog(
      context: context,
      builder: (_) => _PlantSimpleEditDialog(
        plant: plant,
        onSaved: _refresh,
      ),
    );
  }

  // 사진 변경 sheet
  void _showChangePhotoSheet(PlantModel plant) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => _PlantPhotoChangeSheet(
        plant: plant,
        onChanged: _refresh,
      ),
    );
  }

  // 잠금 다이얼로그
  void _showLockDialog(PlantModel plant) {
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
                '식물 잠금',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 14),
              const Text(
                '식물을 잠그면 알림을 받지 않고, 함께한 일수가 늘어나지 않게 돼요.',
                style: TextStyle(fontSize: 14, height: 1.55),
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
                    onPressed: () => Navigator.pop(context),
                    child: const Text(
                      '잠금',
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
      ),
    );
  }

  void _showDeleteDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('식물을 삭제할까요?'),
        content: const Text('삭제하면 성장 기록도 함께 삭제됩니다.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('취소'),
          ),
          TextButton(
            onPressed: () async {
              try {
                await ApiService.instance.deletePlant(widget.plantId);
                if (!mounted) return;
                Navigator.pop(context);
                context.pop();
              } catch (error) {
                if (mounted) {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text(error.toString())));
                }
              }
            },
            child: const Text(
              '삭제',
              style: TextStyle(color: Color(0xFFB94040)),
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
    this.color,
  });

  final String icon;
  final String label;
  final VoidCallback onTap;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final c = color ?? PlantItColors.text;
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _NavIcon(icon, color: c, size: 22),
          const SizedBox(height: 4),
          Text(label, style: TextStyle(fontSize: 10, color: c)),
        ],
      ),
    );
  }
}

class _GuideSectionCard extends StatelessWidget {
  const _GuideSectionCard({required this.guide});

  final PlantCareGuideModel guide;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          if (_hasValue(guide.watering))
            _CareSection(
              icon: 'assets/icons/water.svg',
              label: '물',
              value: guide.watering!,
            ),
          if (_hasValue(guide.sunlight))
            _CareSection(
              icon: 'assets/icons/sun.svg',
              label: '햇빛',
              value: guide.sunlight!,
            ),
          if (_hasValue(guide.temperature) || _hasValue(guide.humidity))
            _CareSection(
              icon: 'assets/icons/temperature.svg',
              label: '온도 & 습도',
              value: [
                if (_hasValue(guide.temperature)) guide.temperature!,
                if (_hasValue(guide.humidity)) guide.humidity!,
              ].join('\n'),
            ),
          if (_hasValue(guide.fertilizer))
            _CareSection(
              icon: 'assets/icons/fertilizer.svg',
              label: '비료',
              value: guide.fertilizer!,
            ),
          if (_hasValue(guide.description))
            _CareSection(
              icon: 'assets/icons/alert.svg',
              label: '주의사항',
              value: guide.description!,
            ),
        ],
      ),
    );
  }

  bool _hasValue(String? v) => v != null && v.trim().isNotEmpty;
}

class _CareSection extends StatelessWidget {
  const _CareSection({
    required this.icon,
    required this.label,
    required this.value,
  });

  final String icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: PlantItColors.paper,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: PlantItColors.line),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _NavIcon(icon, color: PlantItColors.green, size: 18),
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
                    color: PlantItColors.green,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(fontSize: 13, height: 1.55),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _BasicCareCard extends StatelessWidget {
  const _BasicCareCard({required this.plant});

  final PlantModel plant;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: PlantItColors.paper,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: PlantItColors.line),
        ),
        child: Column(
          children: [
            if (plant.wateringCycleDays != null)
              _BasicCareRow(
                label: '물주기 간격',
                value: '${plant.wateringCycleDays}일마다',
              ),
            if (plant.fertilizerCycleDays != null)
              _BasicCareRow(
                label: '비료 간격',
                value: '${plant.fertilizerCycleDays}일마다',
              ),
          ],
        ),
      ),
    );
  }
}

class _BasicCareRow extends StatelessWidget {
  const _BasicCareRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: const TextStyle(
                color: PlantItColors.muted,
                fontSize: 12,
              ),
            ),
          ),
          Text(
            value,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }
}

class _PlantDetailData {
  const _PlantDetailData({required this.plant, this.guide});

  final PlantModel plant;
  final PlantCareGuideModel? guide;
}

// Growth Gallery Screen
class GrowthGalleryScreen extends StatefulWidget {
  const GrowthGalleryScreen({required this.plantId, super.key});

  final int plantId;

  @override
  State<GrowthGalleryScreen> createState() => _GrowthGalleryScreenState();
}

class _GrowthGalleryScreenState extends State<GrowthGalleryScreen> {
  late Future<_GalleryData> _data;

  @override
  void initState() {
    super.initState();
    _data = _load();
  }

  Future<_GalleryData> _load() async {
    final results = await Future.wait([
      ApiService.instance.getPlant(widget.plantId),
      ApiService.instance.getDiaries(widget.plantId),
    ]);
    return _GalleryData(
      plant: results[0] as PlantModel,
      diaries: results[1] as List<PlantDiaryModel>,
    );
  }

  void _refresh() => setState(() => _data = _load());

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<_GalleryData>(
      future: _data,
      builder: (context, snapshot) {
        return Scaffold(
          body: switch (snapshot.connectionState) {
            ConnectionState.done when snapshot.hasData =>
              _body(snapshot.requireData),
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

  Widget _body(_GalleryData data) {
    return SafeArea(
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
                Expanded(
                  child: Text(
                    data.plant.name,
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
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
            child: RefreshIndicator(
              onRefresh: () async => _refresh(),
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
                children: [
                  Row(
                    children: [
                      const Text(
                        '성장 갤러리',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const Spacer(),
                      GestureDetector(
                        onTap: () => _showAddDiary(),
                        child: Container(
                          width: 34,
                          height: 34,
                          decoration: const BoxDecoration(
                            color: PlantItColors.ink,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.add,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  if (data.diaries.isEmpty)
                    const Center(
                      child: Padding(
                        padding: EdgeInsets.only(top: 60),
                        child: Text(
                          '아직 성장 기록이 없어요.\n+ 버튼을 눌러 첫 기록을 남겨보세요.',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: PlantItColors.muted),
                        ),
                      ),
                    )
                  else
                    for (var i = 0; i < data.diaries.length; i++)
                      _DiaryEntry(data.diaries[i], index: i),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showAddDiary() {
    showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => DiaryTypePickerSheet(plantId: widget.plantId),
    ).then((added) {
      if (added == true) _refresh();
    });
  }
}

class _DiaryEntry extends StatelessWidget {
  const _DiaryEntry(this.diary, {required this.index});

  final PlantDiaryModel diary;
  final int index;

  @override
  Widget build(BuildContext context) {
    final hasImage = (diary.imageUrl ?? '').isNotEmpty;
    final date = diary.recordedAt;
    final dateLabel = date != null ? '${date.month}월 ${date.day}일' : '';
    final dayLabel = '${index + 1}일차';

    return Padding(
      padding: const EdgeInsets.only(bottom: 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 날짜 위에
          if (dateLabel.isNotEmpty)
            Text(
              dateLabel,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
              ),
            ),
          if (dateLabel.isNotEmpty) const SizedBox(height: 10),
          // 이미지
          if (hasImage)
            ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: AspectRatio(
                aspectRatio: 1.0,
                child: _PlantImage(url: diary.imageUrl, fit: BoxFit.cover),
              ),
            ),
          const SizedBox(height: 8),
          // 일차
          Text(
            (diary.note?.isNotEmpty ?? false) ? diary.note! : dayLabel,
            style: const TextStyle(fontSize: 13, color: PlantItColors.muted),
          ),
        ],
      ),
    );
  }
}

class _GalleryData {
  const _GalleryData({required this.plant, required this.diaries});

  final PlantModel plant;
  final List<PlantDiaryModel> diaries;
}

// ─── 식물 수정 간단 다이얼로그 ────────────────────────────────────────────────

class _PlantSimpleEditDialog extends StatefulWidget {
  const _PlantSimpleEditDialog({required this.plant, required this.onSaved});

  final PlantModel plant;
  final VoidCallback onSaved;

  @override
  State<_PlantSimpleEditDialog> createState() => _PlantSimpleEditDialogState();
}

class _PlantSimpleEditDialogState extends State<_PlantSimpleEditDialog> {
  late final _name = TextEditingController(text: widget.plant.name);
  bool _saving = false;

  @override
  void dispose() {
    _name.dispose();
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
              '식물 수정',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 18),
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: SizedBox(
                  width: 80,
                  height: 80,
                  child: _PlantImage(url: widget.plant.plantImageUrl),
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              '이름',
              style: TextStyle(fontSize: 12, color: PlantItColors.muted),
            ),
            TextField(
              controller: _name,
              decoration: const InputDecoration(
                hintText: '식물 이름',
                border: UnderlineInputBorder(
                  borderSide: BorderSide(color: PlantItColors.line),
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: PlantItColors.line),
                ),
                contentPadding: EdgeInsets.symmetric(vertical: 8),
              ),
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

  Future<void> _save() async {
    final name = _name.text.trim();
    if (name.isEmpty) return;
    setState(() => _saving = true);
    try {
      await ApiService.instance.updatePlant(
        widget.plant.id,
        name: name,
        speciesName: widget.plant.speciesName,
        plantImageUrl: widget.plant.plantImageUrl,
        wateringCycleDays: widget.plant.wateringCycleDays,
        fertilizerCycleDays: widget.plant.fertilizerCycleDays,
        memo: widget.plant.memo,
      );
      if (mounted) {
        Navigator.pop(context);
        widget.onSaved();
      }
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(error.toString())),
        );
        setState(() => _saving = false);
      }
    }
  }
}

// ─── 사진 변경 bottomsheet ────────────────────────────────────────────────────

class _PlantPhotoChangeSheet extends StatelessWidget {
  const _PlantPhotoChangeSheet({required this.plant, required this.onChanged});

  final PlantModel plant;
  final VoidCallback onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 14, 20, 32),
      decoration: const BoxDecoration(
        color: Color(0xFFF5F0E8),
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 36,
            height: 4,
            decoration: BoxDecoration(
              color: PlantItColors.line,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            '사진 변경',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 20),
          _PhotoOptionButton(
            icon: Icons.camera_alt_outlined,
            label: '사진 촬영',
            color: PlantItColors.green,
            onTap: () async {
              Navigator.pop(context);
              final path = await ImageUploadService.instance
                  .pickPlantImage(ImageSource.camera);
              if (path != null && context.mounted) {
                await _updatePhoto(context, path);
              }
            },
          ),
          const SizedBox(height: 10),
          _PhotoOptionButton(
            icon: Icons.photo_library_outlined,
            label: '사진 업로드',
            color: const Color(0xFF7A9E7E),
            onTap: () async {
              Navigator.pop(context);
              final path = await ImageUploadService.instance
                  .pickPlantImage(ImageSource.gallery);
              if (path != null && context.mounted) {
                await _updatePhoto(context, path);
              }
            },
          ),
          const SizedBox(height: 10),
          _PhotoOptionButton(
            label: '사진 제거',
            color: const Color(0xFFEDE8DF),
            textColor: PlantItColors.text,
            onTap: () async {
              Navigator.pop(context);
              await _updatePhoto(context, '');
            },
          ),
        ],
      ),
    );
  }

  Future<void> _updatePhoto(BuildContext context, String path) async {
    try {
      String? imageUrl;
      if (path.isNotEmpty) {
        imageUrl = await ImageUploadService.instance.uploadIfLocalFile(
          path,
          type: 'plant',
        );
      }
      await ApiService.instance.updatePlant(
        plant.id,
        name: plant.name,
        speciesName: plant.speciesName,
        plantImageUrl: imageUrl ?? (path.isEmpty ? '' : path),
        wateringCycleDays: plant.wateringCycleDays,
        fertilizerCycleDays: plant.fertilizerCycleDays,
        memo: plant.memo,
      );
      onChanged();
    } catch (error) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(error.toString())),
        );
      }
    }
  }
}

class _PhotoOptionButton extends StatelessWidget {
  const _PhotoOptionButton({
    this.icon,
    required this.label,
    required this.color,
    required this.onTap,
    this.textColor = Colors.white,
  });

  final IconData? icon;
  final String label;
  final Color color;
  final Color textColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color,
      borderRadius: BorderRadius.circular(30),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(30),
        child: Container(
          height: 52,
          alignment: Alignment.center,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) ...[
                Icon(icon, color: textColor, size: 18),
                const SizedBox(width: 8),
              ],
              Text(
                label,
                style: TextStyle(
                  color: textColor,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
