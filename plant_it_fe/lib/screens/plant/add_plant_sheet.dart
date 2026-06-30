part of '../app_screen.dart';

class AddPlantSheet extends StatefulWidget {
  const AddPlantSheet({this.plant, this.initialImagePath, super.key});

  final PlantModel? plant;
  final String? initialImagePath;

  @override
  State<AddPlantSheet> createState() => _AddPlantSheetState();
}

class _AddPlantSheetState extends State<AddPlantSheet> {
  late final TextEditingController _name = TextEditingController(
    text: widget.plant?.name ?? '',
  );
  late final TextEditingController _imageUrl = TextEditingController(
    text: widget.initialImagePath ?? widget.plant?.plantImageUrl ?? '',
  );
  late final TextEditingController _memo = TextEditingController(
    text: widget.plant?.memo ?? '',
  );
  PlantCareGuideModel? _selectedGuide;
  bool _saving = false;
  bool _identifying = false;

  @override
  void initState() {
    super.initState();
    final speciesName = widget.plant?.speciesName?.trim();
    if (speciesName != null && speciesName.isNotEmpty) {
      _loadExistingGuide(speciesName);
    }
  }

  @override
  void dispose() {
    _name.dispose();
    _imageUrl.dispose();
    _memo.dispose();
    super.dispose();
  }

  Future<void> _pickImage(ImageSource source) async {
    final path = await ImageUploadService.instance.pickPlantImage(source);
    if (path == null || !mounted) return;
    setState(() => _imageUrl.text = path);
  }

  Future<void> _pickImageFile() async {
    final path = await ImageUploadService.instance.pickPlantImageFile();
    if (path == null || !mounted) return;
    setState(() => _imageUrl.text = path);
  }

  Future<void> _loadExistingGuide(String speciesName) async {
    try {
      final guides = await ApiService.instance.getGuides(keyword: speciesName);
      if (!mounted || guides.isEmpty) return;
      final matched = guides.firstWhere(
        (guide) => guide.speciesName == speciesName,
        orElse: () => guides.first,
      );
      final detail = await ApiService.instance.getGuide(matched.id);
      if (mounted) setState(() => _selectedGuide = detail);
    } catch (_) {
      // Existing custom plants must be re-linked by selecting a guide.
    }
  }

  Future<void> _openGuidePicker() async {
    final guide = await Navigator.push<PlantCareGuideModel>(
      context,
      MaterialPageRoute(
        builder: (_) => _GuidePickerScreen(
          initialKeyword: _selectedGuide?.speciesName,
        ),
      ),
    );
    if (guide != null && mounted) {
      setState(() {
        _selectedGuide = guide;
        if (_imageUrl.text.trim().isEmpty && (guide.imageUrl ?? '').isNotEmpty) {
          _imageUrl.text = guide.imageUrl!;
        }
      });
    }
  }

  Future<void> _identifyFromImage() async {
    if (_imageUrl.text.trim().isEmpty) {
      _showMessage('먼저 사진을 추가해 주세요.');
      return;
    }

    setState(() => _identifying = true);
    try {
      final uploadedImageUrl = await ImageUploadService.instance.uploadIfLocalFile(
        _imageUrl.text,
        type: 'ai',
      );
      if (uploadedImageUrl == null || uploadedImageUrl.isEmpty) {
        throw ApiException('이미지 업로드 URL을 확인하지 못했습니다.');
      }
      _imageUrl.text = uploadedImageUrl;

      final identified = await ApiService.instance.identifyPlant(
        imageUrl: uploadedImageUrl,
      );
      final speciesName = identified.speciesName.trim();
      final lower = speciesName.toLowerCase();
      if (speciesName.isEmpty || lower == '분석 불가' || lower == 'unknown') {
        _showMessage('식물을 인식하지 못했어요. 다른 사진으로 다시 시도해 주세요.');
        return;
      }

      final guides = await ApiService.instance.getGuides(keyword: speciesName);
      if (guides.isEmpty) {
        _showMessage('AI 결과 "$speciesName"와 일치하는 도감 항목이 없습니다.');
        return;
      }

      final matched = guides.firstWhere(
        (guide) => guide.speciesName.toLowerCase() == speciesName.toLowerCase(),
        orElse: () => guides.first,
      );
      final detail = await ApiService.instance.getGuide(matched.id);
      if (!mounted) return;
      setState(() => _selectedGuide = detail);
      _showMessage('도감에서 ${detail.speciesName} 항목을 선택했어요.');
    } catch (error) {
      _showMessage(error.toString());
    } finally {
      if (mounted) setState(() => _identifying = false);
    }
  }

  Future<void> _save() async {
    final guide = _selectedGuide;
    if (_name.text.trim().isEmpty) {
      _showMessage('식물 이름을 입력해 주세요.');
      return;
    }
    if (guide == null) {
      _showMessage('식물종은 도감에서 선택해야 저장할 수 있어요.');
      return;
    }

    setState(() => _saving = true);
    try {
      final uploadedImageUrl = await ImageUploadService.instance.uploadIfLocalFile(
        _imageUrl.text,
        type: 'plant',
      );
      final imageUrl = uploadedImageUrl ?? guide.imageUrl;
      _imageUrl.text = imageUrl ?? '';

      final wateringCycleDays = _cycleDaysFromGuide(guide.watering);
      final fertilizerCycleDays = _cycleDaysFromGuide(guide.fertilizer);

      if (widget.plant == null) {
        await ApiService.instance.createPlant(
          name: _name.text.trim(),
          speciesName: guide.speciesName,
          plantImageUrl: imageUrl,
          wateringCycleDays: wateringCycleDays,
          fertilizerCycleDays: fertilizerCycleDays,
          memo: _memo.text,
        );
      } else {
        await ApiService.instance.updatePlant(
          widget.plant!.id,
          name: _name.text.trim(),
          speciesName: guide.speciesName,
          plantImageUrl: imageUrl,
          wateringCycleDays: wateringCycleDays,
          fertilizerCycleDays: fertilizerCycleDays,
          memo: _memo.text,
        );
      }
      if (mounted) {
        PlantStore.instance.notify();
        Navigator.pop(context, true);
      }
    } catch (error) {
      _showMessage(error.toString());
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  void _showMessage(String message) {
    if (!mounted) return;
    showSB(context, message);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 16, 16, 0),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_back),
                  ),
                  Expanded(
                    child: Text(
                      widget.plant == null ? '식물 추가' : '식물 정보 수정',
                      textAlign: TextAlign.center,
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
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
                children: [
                  _ImagePickerPanel(
                    imagePath: _imageUrl.text,
                    emptyLabel: '식물 사진을 추가해 주세요',
                    height: 240,
                    onCamera: () => _pickImage(ImageSource.camera),
                    onGallery: () => _pickImage(ImageSource.gallery),
                    onFile: _pickImageFile,
                    onClear: _imageUrl.text.trim().isEmpty
                        ? null
                        : () => setState(() => _imageUrl.clear()),
                  ),
                  const SizedBox(height: 18),
                  // 식물종(도감) 선택 — 인라인 필드 + 교체 아이콘
                  _SpeciesPickerField(
                    speciesName: _selectedGuide?.speciesName,
                    onTap: _openGuidePicker,
                    onIdentify: _identifying ? null : _identifyFromImage,
                    identifying: _identifying,
                  ),
                  if (_selectedGuide != null) ...[
                    const SizedBox(height: 12),
                    _GuideCareSummary(guide: _selectedGuide!),
                  ],
                  const SizedBox(height: 20),
                  const Text(
                    '이름',
                    style: TextStyle(fontSize: 12, color: PlantItColors.muted),
                  ),
                  TextField(
                    controller: _name,
                    decoration: const InputDecoration(hintText: '...'),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    '메모',
                    style: TextStyle(fontSize: 12, color: PlantItColors.muted),
                  ),
                  TextField(
                    controller: _memo,
                    minLines: 2,
                    maxLines: 4,
                    decoration: const InputDecoration(hintText: '...'),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
              child: _PrimaryButton(
                label: _saving ? '업로드 중' : '확인',
                expanded: true,
                onTap: _saving || _identifying ? null : _save,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// 식물종 선택 인라인 필드: [식물종 이름] ⇄  + 사진으로 찾기(AI)
class _SpeciesPickerField extends StatelessWidget {
  const _SpeciesPickerField({
    required this.speciesName,
    required this.onTap,
    required this.onIdentify,
    required this.identifying,
  });

  final String? speciesName;
  final VoidCallback onTap;
  final VoidCallback? onIdentify;
  final bool identifying;

  @override
  Widget build(BuildContext context) {
    final hasSpecies = (speciesName ?? '').trim().isNotEmpty;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    hasSpecies ? speciesName!.trim() : '식물종 선택',
                    style: TextStyle(
                      fontSize: 15,
                      color: hasSpecies
                          ? PlantItColors.text
                          : PlantItColors.muted,
                    ),
                  ),
                ),
                const Icon(
                  Icons.swap_horiz,
                  size: 20,
                  color: PlantItColors.muted,
                ),
              ],
            ),
          ),
        ),
        const Divider(height: 1, color: PlantItColors.line),
        const SizedBox(height: 8),
        Align(
          alignment: Alignment.centerLeft,
          child: TextButton.icon(
            onPressed: onIdentify,
            style: TextButton.styleFrom(
              foregroundColor: PlantItColors.green,
              padding: EdgeInsets.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            icon: identifying
                ? const SizedBox(
                    width: 14,
                    height: 14,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.camera_alt_outlined, size: 16),
            label: Text(identifying ? '사진 분석 중' : '사진으로 도감 찾기'),
          ),
        ),
      ],
    );
  }
}

class _GuideCareSummary extends StatelessWidget {
  const _GuideCareSummary({required this.guide});

  final PlantCareGuideModel guide;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE9E1D6)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _GuideCareRow(label: '물주기', value: guide.watering),
          const SizedBox(height: 8),
          _GuideCareRow(label: '비료', value: guide.fertilizer),
          const SizedBox(height: 8),
          _GuideCareRow(label: '빛', value: guide.sunlight),
        ],
      ),
    );
  }
}

class _GuideCareRow extends StatelessWidget {
  const _GuideCareRow({required this.label, required this.value});

  final String label;
  final String? value;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 52,
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: Color(0xFF49684B),
            ),
          ),
        ),
        Expanded(
          child: Text(
            (value ?? '').trim().isEmpty ? '-' : value!.trim(),
            style: const TextStyle(fontSize: 12, height: 1.35),
          ),
        ),
      ],
    );
  }
}

int? _cycleDaysFromGuide(String? text) {
  final value = text?.trim();
  if (value == null || value.isEmpty) return null;

  final lower = value.toLowerCase();
  if (lower.contains('daily') || value.contains('매일')) return 1;

  final number = RegExp(r'\d+').firstMatch(value);

  final weekMatch = RegExp(r'(\d+)\s*(주|week)').firstMatch(lower);
  if (weekMatch != null) {
    return int.parse(weekMatch.group(1)!) * 7;
  }
  if ((lower.contains('week') || value.contains('주')) && number != null) {
    return int.parse(number.group(0)!) * 7;
  }

  final dayMatch = RegExp(r'(\d+)\s*(일|day)').firstMatch(lower);
  if (dayMatch != null) {
    return int.parse(dayMatch.group(1)!);
  }
  if ((value.contains('월') || lower.contains('month')) && number != null) {
    return int.parse(number.group(0)!) * 30;
  }

  if (number != null) return int.parse(number.group(0)!);

  return null;
}

// ─── 도감 선택 풀스크린 (이름만 리스트) ────────────────────────────────────────

class _GuidePickerScreen extends StatefulWidget {
  const _GuidePickerScreen({this.initialKeyword});

  final String? initialKeyword;

  @override
  State<_GuidePickerScreen> createState() => _GuidePickerScreenState();
}

class _GuidePickerScreenState extends State<_GuidePickerScreen> {
  late final TextEditingController _keyword =
      TextEditingController(text: widget.initialKeyword ?? '');
  late Future<List<PlantCareGuideModel>> _guides = _loadGuides();
  int? _loadingId;

  Future<List<PlantCareGuideModel>> _loadGuides() =>
      ApiService.instance.getGuides(keyword: _keyword.text);

  void _search() => setState(() => _guides = _loadGuides());

  Future<void> _select(PlantCareGuideModel guide) async {
    setState(() => _loadingId = guide.id);
    try {
      final detail = await ApiService.instance.getGuide(guide.id);
      if (mounted) Navigator.pop(context, detail);
    } catch (error) {
      if (mounted) {
        showSB(context, error.toString());
        setState(() => _loadingId = null);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 16, 16, 0),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_back),
                  ),
                  const Expanded(
                    child: Text(
                      '식물 추가',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const SizedBox(width: 48),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                height: 44,
                decoration: BoxDecoration(
                  color: PlantItColors.paper,
                  borderRadius: BorderRadius.circular(22),
                ),
                child: TextField(
                  controller: _keyword,
                  textInputAction: TextInputAction.search,
                  onSubmitted: (_) => _search(),
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.search, size: 20),
                    hintText: '검색',
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: FutureBuilder<List<PlantCareGuideModel>>(
                future: _guides,
                builder: (context, snapshot) {
                  if (snapshot.connectionState != ConnectionState.done) {
                    return const _CenteredProgress();
                  }
                  final guides = snapshot.data ?? [];
                  if (guides.isEmpty) {
                    return const Center(
                      child: Text(
                        '검색 결과가 없어요.',
                        style: TextStyle(color: PlantItColors.muted),
                      ),
                    );
                  }
                  return ListView.separated(
                    padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
                    itemCount: guides.length,
                    separatorBuilder: (_, __) => const Divider(
                      color: PlantItColors.line,
                      height: 1,
                    ),
                    itemBuilder: (_, i) {
                      final guide = guides[i];
                      final isLoading = _loadingId == guide.id;
                      return InkWell(
                        onTap: isLoading ? null : () => _select(guide),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  guide.speciesName,
                                  style: const TextStyle(fontSize: 15),
                                ),
                              ),
                              if (isLoading)
                                const SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _keyword.dispose();
    super.dispose();
  }
}

// ─── 식물 추가 - 사진 선택 bottomsheet ────────────────────────────────────────

class AddPlantPhotoPickerSheet extends StatelessWidget {
  const AddPlantPhotoPickerSheet({super.key});

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
            '식물 추가',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 20),
          _AddPlantOptionButton(
            icon: Icons.camera_alt_outlined,
            label: '사진 촬영',
            color: PlantItColors.green,
            onTap: () async {
              final navigator = Navigator.of(context);
              final path = await ImageUploadService.instance
                  .pickPlantImage(ImageSource.camera);
              // 촬영을 취소하면 선택 시트를 유지한다.
              if (path != null) navigator.pop(path);
            },
          ),
          const SizedBox(height: 10),
          _AddPlantOptionButton(
            icon: Icons.photo_library_outlined,
            label: '사진 업로드',
            color: const Color(0xFF7A9E7E),
            onTap: () async {
              final navigator = Navigator.of(context);
              final path = await ImageUploadService.instance
                  .pickPlantImage(ImageSource.gallery);
              if (path != null) navigator.pop(path);
            },
          ),
          const SizedBox(height: 10),
          _AddPlantOptionButton(
            label: '사진 없이 등록',
            color: const Color(0xFFEDE8DF),
            textColor: PlantItColors.text,
            // 빈 문자열 = "사진 없이 등록 진행". null(드래그 닫기)과 구분한다.
            onTap: () => Navigator.pop(context, ''),
          ),
        ],
      ),
    );
  }
}

class _AddPlantOptionButton extends StatelessWidget {
  const _AddPlantOptionButton({
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
