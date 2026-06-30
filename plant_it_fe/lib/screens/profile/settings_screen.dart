part of '../app_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 34, 16, 28),
          children: [
            _TopBar(title: '설정', onBack: () => context.pop()),
            const SizedBox(height: 30),
            _SectionHeader(icon: Icons.notifications_outlined, label: '알림'),
            const SizedBox(height: 8),
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('알림 설정', style: TextStyle(fontSize: 15)),
              subtitle: const Text(
                '식물별 물주기·비료·성장 기록 알림을 설정합니다.',
                style: TextStyle(fontSize: 12, color: PlantItColors.muted),
              ),
              trailing: const Icon(Icons.chevron_right, color: PlantItColors.muted),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const _NotificationSettingsScreen()),
              ),
            ),
            const SizedBox(height: 24),
            InkWell(
              onTap: () => _showResetDataDialog(context),
              borderRadius: BorderRadius.circular(8),
              child: const Padding(
                padding: EdgeInsets.symmetric(vertical: 14),
                child: Text(
                  '데이터 초기화',
                  style: TextStyle(fontSize: 15, color: PlantItColors.text),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showResetDataDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => _ConfirmThenPasswordDialog(
        title: '데이터 초기화',
        confirmMessage: '데이터를 초기화할까요? 기록한 식물과 관련된 데이터가 모두 없어져요.',
        passwordMessage: '데이터를 초기화하려면 현재 비밀번호를 입력해 주세요.',
        actionLabel: '초기화',
        actionColor: const Color(0xFFB94040),
        onConfirm: (password) => ApiService.instance.resetData(password),
        onSuccess: (ctx) {
          PlantStore.instance.notify();
          Navigator.pop(ctx);
        },
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 16, color: PlantItColors.muted),
        const SizedBox(width: 6),
        Text(
          label,
          style: const TextStyle(fontSize: 13, color: PlantItColors.muted),
        ),
      ],
    );
  }
}

// ─── 식물별 알림 설정 화면 ────────────────────────────────────────────────────

class _NotificationSettingsScreen extends StatefulWidget {
  const _NotificationSettingsScreen();

  @override
  State<_NotificationSettingsScreen> createState() => _NotificationSettingsScreenState();
}

class _NotificationSettingsScreenState extends State<_NotificationSettingsScreen> {
  late Future<_NotificationSettingsData> _data;

  @override
  void initState() {
    super.initState();
    _data = _load();
  }

  Future<_NotificationSettingsData> _load() async {
    final plants = await ApiService.instance.getPlants();
    final settings = await ApiService.instance.getNotificationSettings();
    final settingsByPlantId = {
      for (final s in settings) (s['plantId'] as num?)?.toInt(): s,
    };
    return _NotificationSettingsData(plants: plants, settingsByPlantId: settingsByPlantId);
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
                      '알림 설정',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                    ),
                  ),
                  const SizedBox(width: 48),
                ],
              ),
            ),
            Expanded(
              child: FutureBuilder<_NotificationSettingsData>(
                future: _data,
                builder: (context, snapshot) {
                  if (snapshot.connectionState != ConnectionState.done) {
                    return const _CenteredProgress();
                  }
                  if (snapshot.hasError) {
                    return _ErrorState(
                      message: snapshot.error.toString(),
                      onRetry: () => setState(() => _data = _load()),
                    );
                  }
                  final data = snapshot.requireData;
                  if (data.plants.isEmpty) {
                    return const _EmptyCard(
                      title: '등록된 식물이 없어요',
                      body: '식물을 등록하면 알림을 설정할 수 있어요.',
                    );
                  }
                  return ListView.separated(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
                    itemCount: data.plants.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (_, i) {
                      final plant = data.plants[i];
                      final setting = data.settingsByPlantId[plant.id];
                      return _PlantNotificationCard(
                        plant: plant,
                        setting: setting,
                        onChanged: () => setState(() => _data = _load()),
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
}

class _NotificationSettingsData {
  const _NotificationSettingsData({
    required this.plants,
    required this.settingsByPlantId,
  });

  final List<PlantModel> plants;
  final Map<int?, Map<String, dynamic>> settingsByPlantId;
}

class _PlantNotificationCard extends StatefulWidget {
  const _PlantNotificationCard({
    required this.plant,
    required this.setting,
    required this.onChanged,
  });

  final PlantModel plant;
  final Map<String, dynamic>? setting;
  final VoidCallback onChanged;

  @override
  State<_PlantNotificationCard> createState() => _PlantNotificationCardState();
}

class _PlantNotificationCardState extends State<_PlantNotificationCard> {
  late bool _watering;
  late bool _fertilizer;
  late bool _growthRecord;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    final s = widget.setting;
    _watering = s?['wateringEnabled'] as bool? ?? false;
    _fertilizer = s?['fertilizerEnabled'] as bool? ?? false;
    _growthRecord = s?['growthRecordEnabled'] as bool? ?? false;
  }

  Future<void> _update({
    bool? watering,
    bool? fertilizer,
    bool? growthRecord,
  }) async {
    if (_saving) return;
    final next = _PlantNotificationCardState._applyUpdate(
      watering: watering ?? _watering,
      fertilizer: fertilizer ?? _fertilizer,
      growthRecord: growthRecord ?? _growthRecord,
    );
    setState(() {
      _watering = next.$1;
      _fertilizer = next.$2;
      _growthRecord = next.$3;
      _saving = true;
    });
    try {
      await ApiService.instance.updateNotificationSetting(
        plantId: widget.plant.id,
        wateringEnabled: next.$1,
        fertilizerEnabled: next.$2,
        growthRecordEnabled: next.$3,
      );
    } catch (_) {
      if (mounted) {
        setState(() {
          _watering = watering == null ? _watering : !next.$1;
          _fertilizer = fertilizer == null ? _fertilizer : !next.$2;
          _growthRecord = growthRecord == null ? _growthRecord : !next.$3;
        });
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  static (bool, bool, bool) _applyUpdate({
    required bool watering,
    required bool fertilizer,
    required bool growthRecord,
  }) => (watering, fertilizer, growthRecord);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: PlantItColors.paper,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: SizedBox(
                  width: 36,
                  height: 36,
                  child: _PlantImage(url: widget.plant.plantImageUrl),
                ),
              ),
              const SizedBox(width: 10),
              Text(
                widget.plant.name,
                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
              ),
              if (_saving) ...[
                const SizedBox(width: 8),
                const SizedBox(
                  width: 12,
                  height: 12,
                  child: CircularProgressIndicator(strokeWidth: 1.5, color: PlantItColors.green),
                ),
              ],
            ],
          ),
          const SizedBox(height: 10),
          const Divider(height: 1, color: PlantItColors.line),
          const SizedBox(height: 6),
          _NotificationToggle(
            label: '물주기 알림',
            icon: Icons.water_drop_outlined,
            value: _watering,
            onChanged: _saving ? null : (v) => _update(watering: v),
          ),
          _NotificationToggle(
            label: '비료 알림',
            icon: Icons.eco_outlined,
            value: _fertilizer,
            onChanged: _saving ? null : (v) => _update(fertilizer: v),
          ),
          _NotificationToggle(
            label: '성장 기록 알림',
            icon: Icons.photo_library_outlined,
            value: _growthRecord,
            onChanged: _saving ? null : (v) => _update(growthRecord: v),
          ),
        ],
      ),
    );
  }
}

class _NotificationToggle extends StatelessWidget {
  const _NotificationToggle({
    required this.label,
    required this.icon,
    required this.value,
    required this.onChanged,
  });

  final String label;
  final IconData icon;
  final bool value;
  final ValueChanged<bool>? onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 16, color: PlantItColors.muted),
        const SizedBox(width: 8),
        Expanded(
          child: Text(label, style: const TextStyle(fontSize: 14)),
        ),
        Switch(
          value: value,
          onChanged: onChanged,
          activeColor: PlantItColors.green,
        ),
      ],
    );
  }
}
