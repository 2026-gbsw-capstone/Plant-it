part of '../app_screen.dart';

class NotificationHistoryScreen extends StatefulWidget {
  const NotificationHistoryScreen({super.key});

  @override
  State<NotificationHistoryScreen> createState() =>
      _NotificationHistoryScreenState();
}

class _NotificationHistoryScreenState
    extends State<NotificationHistoryScreen> {
  late Future<List<Map<String, dynamic>>> _histories;

  @override
  void initState() {
    super.initState();
    _histories = ApiService.instance.getNotificationHistories();
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
                    onPressed: () => context.pop(),
                    icon: const Icon(Icons.arrow_back),
                  ),
                  const Expanded(
                    child: Text(
                      '알림',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: const Text(
                      '모두 읽음',
                      style: TextStyle(
                        fontSize: 13,
                        color: PlantItColors.muted,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: FutureBuilder<List<Map<String, dynamic>>>(
                future: _histories,
                builder: (context, snapshot) {
                  if (snapshot.connectionState != ConnectionState.done) {
                    return const _CenteredProgress();
                  }
                  final items = snapshot.data ?? [];
                  if (items.isEmpty) {
                    return const Center(
                      child: Text(
                        '알림이 없어요.',
                        style: TextStyle(color: PlantItColors.muted),
                      ),
                    );
                  }
                  return ListView.separated(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
                    itemCount: items.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 10),
                    itemBuilder: (_, i) => _NotificationCard(data: items[i]),
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

class _NotificationCard extends StatelessWidget {
  const _NotificationCard({required this.data});

  final Map<String, dynamic> data;

  @override
  Widget build(BuildContext context) {
    final type = data['notificationType'] as String? ?? '';
    final plantName = data['plantName'] as String? ?? '';
    final (text, bgColor, iconColor, icon) = _resolveStyle(type, plantName);

    return Container(
      padding: const EdgeInsets.fromLTRB(14, 14, 10, 14),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: iconColor),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 13, height: 1.45),
            ),
          ),
          GestureDetector(
            onTap: () {},
            child: const Icon(Icons.close, size: 16, color: PlantItColors.muted),
          ),
        ],
      ),
    );
  }

  (String, Color, Color, IconData) _resolveStyle(
    String type,
    String plantName,
  ) {
    switch (type) {
      case 'WATERING':
        return (
          '$plantName에게 물을 줄 때가 되었어요.',
          const Color(0xFFD6E8F5),
          const Color(0xFF4F86D8),
          Icons.water_drop_outlined,
        );
      case 'FERTILIZER':
        return (
          '$plantName에게 비료를 줄 때가 되었어요.',
          const Color(0xFFF5EDDA),
          const Color(0xFFB07D3A),
          Icons.eco_outlined,
        );
      default:
        return (
          '알림이 도착했어요.',
          const Color(0xFFE8EDE3),
          PlantItColors.green,
          Icons.notifications_outlined,
        );
    }
  }
}
