part of '../app_screen.dart';

class DiarySheet extends StatefulWidget {
  const DiarySheet({required this.plantId, super.key});

  final int plantId;

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

  Future<void> _save() async {
    setState(() => _saving = true);
    try {
      await ApiService.instance.createDiary(
        widget.plantId,
        imageUrl: _imageUrl.text,
        note: _note.text,
      );
      if (mounted) Navigator.pop(context, true);
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(error.toString())));
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '성장 기록 추가',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _imageUrl,
            decoration: const InputDecoration(hintText: '사진 URL'),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: _note,
            minLines: 3,
            maxLines: 5,
            decoration: const InputDecoration(hintText: '오늘의 기록'),
          ),
          const SizedBox(height: 16),
          _PrimaryButton(
            label: _saving ? '저장 중' : '기록하기',
            expanded: true,
            onTap: _saving ? null : _save,
          ),
        ],
      ),
    );
  }
}
