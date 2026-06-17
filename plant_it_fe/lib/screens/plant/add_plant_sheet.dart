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
      if (speciesName.isEmpty || speciesName == '분석 불가') {
        _showMessage('사진에서 도감 식물을 찾지 못했습니다.');
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
      if (mounted) Navigator.pop(context, true);
    } catch (error) {
      _showMessage(error.toString());
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  void _showMessage(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return _SheetFrame(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            widget.plant == null ? '식물 추가' : '식물 정보 수정',
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 18),
          _ImagePickerPanel(
            imagePath: _imageUrl.text,
            emptyLabel: '식물 사진을 추가해 주세요',
            onCamera: () => _pickImage(ImageSource.camera),
            onGallery: () => _pickImage(ImageSource.gallery),
            onFile: _pickImageFile,
            onClear: _imageUrl.text.trim().isEmpty
                ? null
                : () => setState(() => _imageUrl.clear()),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _name,
            decoration: const InputDecoration(
              labelText: '식물 이름',
              hintText: '식물 이름',
            ),
          ),
          const SizedBox(height: 10),
          _GuideSelectPanel(
            guide: _selectedGuide,
            onSelect: _openGuidePicker,
            onIdentify: _identifying ? null : _identifyFromImage,
            identifying: _identifying,
          ),
          const SizedBox(height: 10),
          if (_selectedGuide != null) ...[
            _GuideCareSummary(guide: _selectedGuide!),
            const SizedBox(height: 10),
          ],
          TextField(
            controller: _memo,
            minLines: 2,
            maxLines: 4,
            decoration: const InputDecoration(labelText: '메모', hintText: '메모'),
          ),
          const SizedBox(height: 16),
          _PrimaryButton(
            label: _saving ? '업로드 중' : '저장하기',
            expanded: true,
            onTap: _saving || _identifying ? null : _save,
          ),
        ],
      ),
    );
  }
}

class _GuideSelectPanel extends StatelessWidget {
  const _GuideSelectPanel({
    required this.guide,
    required this.onSelect,
    required this.onIdentify,
    required this.identifying,
  });

  final PlantCareGuideModel? guide;
  final VoidCallback onSelect;
  final VoidCallback? onIdentify;
  final bool identifying;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F3EA),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE4D9C9)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  guide == null ? '도감 식물을 선택해 주세요' : guide!.speciesName,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              TextButton(onPressed: onSelect, child: const Text('도감 선택')),
            ],
          ),
          const SizedBox(height: 8),
          OutlinedButton.icon(
            onPressed: onIdentify,
            icon: identifying
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.auto_awesome, size: 18),
            label: Text(identifying ? '사진 분석 중' : '사진으로 도감 찾기'),
          ),
        ],
      ),
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

class _GuidePickerSheet extends StatefulWidget {
  const _GuidePickerSheet({this.initialKeyword});

  final String? initialKeyword;

  @override
  State<_GuidePickerSheet> createState() => _GuidePickerSheetState();
}

class _GuidePickerSheetState extends State<_GuidePickerSheet> {
  late final TextEditingController _keyword = TextEditingController(
    text: widget.initialKeyword ?? '',
  );
  late Future<List<PlantCareGuideModel>> _guides = _loadGuides();
  int? _loadingGuideId;

  @override
  void dispose() {
    _keyword.dispose();
    super.dispose();
  }

  Future<List<PlantCareGuideModel>> _loadGuides() {
    return ApiService.instance.getGuides(keyword: _keyword.text);
  }

  void _search() {
    setState(() => _guides = _loadGuides());
  }

  Future<void> _selectGuide(PlantCareGuideModel guide) async {
    setState(() => _loadingGuideId = guide.id);
    try {
      final detail = await ApiService.instance.getGuide(guide.id);
      if (mounted) Navigator.pop(context, detail);
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error.toString())),
      );
      setState(() => _loadingGuideId = null);
    }
  }

  @override
  Widget build(BuildContext context) {
    return _SheetFrame(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            '도감에서 선택',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 14),
          TextField(
            controller: _keyword,
            textInputAction: TextInputAction.search,
            onSubmitted: (_) => _search(),
            decoration: InputDecoration(
              hintText: '식물 이름 검색',
              suffixIcon: IconButton(
                onPressed: _search,
                icon: const Icon(Icons.search),
              ),
            ),
          ),
          const SizedBox(height: 12),
          ConstrainedBox(
            constraints: const BoxConstraints(maxHeight: 360),
            child: FutureBuilder<List<PlantCareGuideModel>>(
              future: _guides,
              builder: (context, snapshot) {
                if (snapshot.connectionState != ConnectionState.done) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(28),
                      child: CircularProgressIndicator(),
                    ),
                  );
                }
                final guides = snapshot.data ?? const [];
                if (guides.isEmpty) {
                  return const Padding(
                    padding: EdgeInsets.all(28),
                    child: Text('검색 결과가 없습니다.', textAlign: TextAlign.center),
                  );
                }
                return ListView.separated(
                  shrinkWrap: true,
                  itemCount: guides.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 8),
                  itemBuilder: (context, index) {
                    final guide = guides[index];
                    return _GuideOptionTile(
                      guide: guide,
                      loading: _loadingGuideId == guide.id,
                      onTap: () => _selectGuide(guide),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _GuideOptionTile extends StatelessWidget {
  const _GuideOptionTile({
    required this.guide,
    required this.loading,
    required this.onTap,
  });

  final PlantCareGuideModel guide;
  final bool loading;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: loading ? null : onTap,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: const Color(0xFFE9E1D6)),
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: SizedBox(
                width: 48,
                height: 48,
                child: _PlantImage(
                  url: guide.imageUrl,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                guide.speciesName,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            if (loading)
              const SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            else
              const Icon(Icons.chevron_right, color: Color(0xFF6F806D)),
          ],
        ),
      ),
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
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(error.toString())),
        );
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
              Navigator.pop(context);
              final path = await ImageUploadService.instance
                  .pickPlantImage(ImageSource.camera);
              if (path != null && context.mounted) {
                _openAddSheet(context, imagePath: path);
              }
            },
          ),
          const SizedBox(height: 10),
          _AddPlantOptionButton(
            icon: Icons.photo_library_outlined,
            label: '사진 업로드',
            color: const Color(0xFF7A9E7E),
            onTap: () async {
              Navigator.pop(context);
              final path = await ImageUploadService.instance
                  .pickPlantImage(ImageSource.gallery);
              if (path != null && context.mounted) {
                _openAddSheet(context, imagePath: path);
              }
            },
          ),
          const SizedBox(height: 10),
          _AddPlantOptionButton(
            label: '사진 없이 등록',
            color: const Color(0xFFEDE8DF),
            textColor: PlantItColors.text,
            onTap: () {
              Navigator.pop(context);
              _openAddSheet(context);
            },
          ),
        ],
      ),
    );
  }

  void _openAddSheet(BuildContext context, {String? imagePath}) {
    showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => AddPlantSheet(initialImagePath: imagePath),
    ).then((created) {
      if (created == true && context.mounted) {
        Navigator.pop(context, true);
      }
    });
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
