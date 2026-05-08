part of '../app_screen.dart';

class AddPlantSheet extends StatefulWidget {
  const AddPlantSheet({this.plant, super.key});

  final PlantModel? plant;

  @override
  State<AddPlantSheet> createState() => _AddPlantSheetState();
}

class _AddPlantSheetState extends State<AddPlantSheet> {
  late final TextEditingController _name = TextEditingController(
    text: widget.plant?.name ?? '',
  );
  late final TextEditingController _species = TextEditingController(
    text: widget.plant?.speciesName ?? '',
  );
  late final TextEditingController _imageUrl = TextEditingController(
    text: widget.plant?.plantImageUrl ?? '',
  );
  late final TextEditingController _watering = TextEditingController(
    text: widget.plant?.wateringCycleDays?.toString() ?? '',
  );
  late final TextEditingController _fertilizer = TextEditingController(
    text: widget.plant?.fertilizerCycleDays?.toString() ?? '',
  );
  late final TextEditingController _memo = TextEditingController(
    text: widget.plant?.memo ?? '',
  );
  bool _saving = false;

  @override
  void dispose() {
    _name.dispose();
    _species.dispose();
    _imageUrl.dispose();
    _watering.dispose();
    _fertilizer.dispose();
    _memo.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    setState(() => _saving = true);
    try {
      if (widget.plant == null) {
        await ApiService.instance.createPlant(
          name: _name.text,
          speciesName: _species.text,
          plantImageUrl: _imageUrl.text,
          wateringCycleDays: int.tryParse(_watering.text),
          fertilizerCycleDays: int.tryParse(_fertilizer.text),
          memo: _memo.text,
        );
      } else {
        await ApiService.instance.updatePlant(
          widget.plant!.id,
          name: _name.text,
          speciesName: _species.text,
          plantImageUrl: _imageUrl.text,
          wateringCycleDays: int.tryParse(_watering.text),
          fertilizerCycleDays: int.tryParse(_fertilizer.text),
          memo: _memo.text,
        );
      }
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
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            widget.plant == null ? '식물 추가' : '식물 정보 수정',
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 18),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: SizedBox(
              height: 188,
              child: widget.plant?.plantImageUrl?.isNotEmpty ?? false
                  ? _PlantImage(url: widget.plant!.plantImageUrl)
                  : const _CheckeredTile(),
            ),
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
          TextField(
            controller: _species,
            decoration: const InputDecoration(
              labelText: '식물 종류',
              hintText: '식물 종류',
            ),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: _imageUrl,
            decoration: const InputDecoration(
              labelText: '사진 URL',
              hintText: '사진 URL',
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _watering,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: '물 주기',
                    hintText: '일',
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: TextField(
                  controller: _fertilizer,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: '비료 주기',
                    hintText: '일',
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          TextField(
            controller: _memo,
            minLines: 2,
            maxLines: 4,
            decoration: const InputDecoration(labelText: '메모', hintText: '메모'),
          ),
          const SizedBox(height: 16),
          _PrimaryButton(
            label: _saving ? '저장 중' : '저장하기',
            expanded: true,
            onTap: _saving ? null : _save,
          ),
        ],
      ),
    );
  }
}
