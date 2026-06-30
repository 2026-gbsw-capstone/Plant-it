part of '../app_screen.dart';

// ─── 갤러리 등록 선택 bottomsheet ─────────────────────────────────────────────
// 성장 기록(사진+메모) vs 순간 기록(텍스트만) 선택

class DiaryTypePickerSheet extends StatelessWidget {
  const DiaryTypePickerSheet({required this.plantId, super.key});

  final int plantId;

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
            '갤러리 등록',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 20),
          _DiaryTypeButton(
            icon: Icons.photo_library_outlined,
            label: '성장 기록',
            color: PlantItColors.green,
            onTap: () {
              Navigator.pop(context);
              Navigator.push<bool>(
                context,
                MaterialPageRoute(
                  builder: (_) => DiaryScreen(plantId: plantId),
                ),
              ).then((added) {
                if (added == true && context.mounted) {
                  Navigator.pop(context, true);
                }
              });
            },
          ),
          const SizedBox(height: 10),
          _DiaryTypeButton(
            icon: Icons.add,
            label: '순간 기록',
            color: const Color(0xFF7A9E7E),
            onTap: () {
              Navigator.pop(context);
              Navigator.push<bool>(
                context,
                MaterialPageRoute(
                  builder: (_) => DiaryScreen(plantId: plantId, momentOnly: true),
                ),
              ).then((added) {
                if (added == true && context.mounted) {
                  Navigator.pop(context, true);
                }
              });
            },
          ),
        ],
      ),
    );
  }
}

class _DiaryTypeButton extends StatelessWidget {
  const _DiaryTypeButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final Color color;
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
              Icon(icon, color: Colors.white, size: 18),
              const SizedBox(width: 8),
              Text(
                label,
                style: const TextStyle(
                  color: Colors.white,
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

// ─── 갤러리 등록 시트 ─────────────────────────────────────────────────────────

class DiarySheet extends StatefulWidget {
  const DiarySheet({required this.plantId, this.momentOnly = false, super.key});

  final int plantId;
  final bool momentOnly;

  @override
  State<DiarySheet> createState() => _DiarySheetState();
}

class _DiarySheetState extends State<DiarySheet> {
  final _imageUrl = TextEditingController();
  final _note = TextEditingController();
  bool _saving = false;

  @override
  void dispose() {
    _imageUrl.dispose();
    _note.dispose();
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

  Future<void> _confirmAndSave() async {
    // 확인 다이얼로그 먼저 표시
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => _GalleryConfirmDialog(),
    );
    if (confirmed != true || !mounted) return;
    await _save();
  }

  Future<void> _save() async {
    setState(() => _saving = true);
    try {
      final imageUrl = await ImageUploadService.instance.uploadIfLocalFile(
        _imageUrl.text,
        type: 'diary',
      );
      _imageUrl.text = imageUrl ?? '';
      await ApiService.instance.createDiary(
        widget.plantId,
        imageUrl: imageUrl,
        note: _note.text,
        analyzeHealth: !widget.momentOnly,
        diaryType: widget.momentOnly ? 'MOMENT' : 'GROWTH',
      );
      if (mounted) {
        PlantStore.instance.notify();
        Navigator.pop(context, true);
      }
    } catch (error) {
      if (mounted) {
        showSB(context, error.toString());
      }
    } finally {
      if (mounted) setState(() => _saving = false);
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
            '갤러리 등록',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 18),
          _ImagePickerPanel(
            imagePath: _imageUrl.text,
            emptyLabel: widget.momentOnly ? '순간 사진' : '오늘의 성장 사진',
            height: 220,
            onCamera: () => _pickImage(ImageSource.camera),
            onGallery: () => _pickImage(ImageSource.gallery),
            onFile: _pickImageFile,
            onClear: _imageUrl.text.trim().isEmpty
                ? null
                : () => setState(() => _imageUrl.clear()),
          ),
          const SizedBox(height: 16),
          Text(
            widget.momentOnly ? '메모' : '한마디',
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 6),
          TextField(
            controller: _note,
            minLines: 2,
            maxLines: 4,
            decoration: const InputDecoration(hintText: '...'),
          ),
          const SizedBox(height: 16),
          _PrimaryButton(
            label: _saving
                ? (widget.momentOnly ? '업로드 중' : 'AI 분석 중')
                : '확인',
            expanded: true,
            onTap: _saving ? null : _confirmAndSave,
          ),
        ],
      ),
    );
  }
}

// ─── 갤러리 등록 확인 다이얼로그 ─────────────────────────────────────────────

class _GalleryConfirmDialog extends StatelessWidget {
  const _GalleryConfirmDialog();

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
              '갤러리 등록',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 14),
            const Text(
              '성장 갤러리에 기록한 사진과 한마디는 수정할 수 없어요. 이대로 등록할까요?',
              style: TextStyle(fontSize: 14, height: 1.55),
            ),
            const SizedBox(height: 22),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: const Text(
                    '취소',
                    style: TextStyle(color: PlantItColors.muted),
                  ),
                ),
                const SizedBox(width: 8),
                TextButton(
                  onPressed: () => Navigator.pop(context, true),
                  child: const Text(
                    '등록',
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
}

// ─── 갤러리 등록 풀스크린 ────────────────────────────────────────────────────

class DiaryScreen extends StatefulWidget {
  const DiaryScreen({required this.plantId, this.momentOnly = false, super.key});

  final int plantId;
  final bool momentOnly;

  @override
  State<DiaryScreen> createState() => _DiaryScreenState();
}

class _DiaryScreenState extends State<DiaryScreen> {
  final _imageUrl = TextEditingController();
  final _note = TextEditingController();
  bool _saving = false;

  @override
  void dispose() {
    _imageUrl.dispose();
    _note.dispose();
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

  Future<void> _confirmAndSave() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => _GalleryConfirmDialog(),
    );
    if (confirmed != true || !mounted) return;
    await _save();
  }

  Future<void> _save() async {
    setState(() => _saving = true);
    try {
      final imageUrl = await ImageUploadService.instance.uploadIfLocalFile(
        _imageUrl.text,
        type: 'diary',
      );
      await ApiService.instance.createDiary(
        widget.plantId,
        imageUrl: imageUrl,
        note: _note.text,
        analyzeHealth: !widget.momentOnly,
        diaryType: widget.momentOnly ? 'MOMENT' : 'GROWTH',
      );
      if (mounted) {
        PlantStore.instance.notify();
        Navigator.pop(context, true);
      }
    } catch (error) {
      if (mounted) {
        showSB(context, error.toString());
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
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
                  const Expanded(
                    child: Text(
                      '갤러리 등록',
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
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                children: [
                  _ImagePickerPanel(
                    imagePath: _imageUrl.text,
                    emptyLabel: widget.momentOnly ? '순간 사진' : '오늘의 성장 사진',
                    height: 280,
                    onCamera: () => _pickImage(ImageSource.camera),
                    onGallery: () => _pickImage(ImageSource.gallery),
                    onFile: _pickImageFile,
                    onClear: _imageUrl.text.trim().isEmpty
                        ? null
                        : () => setState(() => _imageUrl.clear()),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    widget.momentOnly ? '메모' : '한마디',
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 6),
                  TextField(
                    controller: _note,
                    minLines: 2,
                    maxLines: 4,
                    decoration: const InputDecoration(hintText: '...'),
                  ),
                  const SizedBox(height: 24),
                  _PrimaryButton(
                    label: _saving
                        ? (widget.momentOnly ? '업로드 중' : 'AI 분석 중')
                        : '확인',
                    expanded: true,
                    onTap: _saving ? null : _confirmAndSave,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
