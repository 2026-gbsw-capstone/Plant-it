part of '../app_screen.dart';

class EncyclopediaTab extends StatefulWidget {
  const EncyclopediaTab({super.key});

  @override
  State<EncyclopediaTab> createState() => _EncyclopediaTabState();
}

class _EncyclopediaTabState extends State<EncyclopediaTab> {
  late Future<List<PlantCareGuideModel>> _guides = ApiService.instance
      .getGuides();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<PlantCareGuideModel>>(
      future: _guides,
      builder: (context, snapshot) {
        return ListView(
          padding: const EdgeInsets.fromLTRB(20, 18, 20, 28),
          children: [
            const Text(
              '식물 도감',
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 16),
            TextField(
              onSubmitted: (keyword) => setState(
                () => _guides = ApiService.instance.getGuides(keyword: keyword),
              ),
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.search),
                hintText: '식물 이름 검색',
              ),
            ),
            const SizedBox(height: 18),
            if (snapshot.connectionState != ConnectionState.done)
              const _CenteredProgress()
            else if (snapshot.hasError)
              _ErrorState(
                message: snapshot.error.toString(),
                onRetry: () =>
                    setState(() => _guides = ApiService.instance.getGuides()),
              )
            else if (snapshot.requireData.isEmpty)
              const _EmptyCard(
                title: '도감 데이터가 없어요',
                body: '관리자 페이지에서 식물도감을 등록하면 이곳에 표시됩니다.',
              )
            else
              for (final guide in snapshot.requireData)
                _EncyclopediaCard(guide: guide),
          ],
        );
      },
    );
  }
}
