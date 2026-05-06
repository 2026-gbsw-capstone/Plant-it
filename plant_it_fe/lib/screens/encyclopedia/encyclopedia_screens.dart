import 'package:flutter/material.dart';
import 'package:plant_it_fe/screens/shared/app_routes.dart';
import 'package:plant_it_fe/screens/shared/app_theme.dart';
import 'package:plant_it_fe/screens/shared/app_widgets.dart';
import 'package:plant_it_fe/screens/shared/mock_data.dart';

class EncyclopediaScreen extends StatefulWidget {
  const EncyclopediaScreen({super.key});

  @override
  State<EncyclopediaScreen> createState() => _EncyclopediaScreenState();
}

class _EncyclopediaScreenState extends State<EncyclopediaScreen> {
  String _keyword = '';

  @override
  Widget build(BuildContext context) {
    final guides = demoCareGuides
        .where((guide) => guide.model.speciesName.contains(_keyword))
        .toList();

    return PrototypeScaffold(
      includeBottomSafeArea: false,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 36, 16, 120),
        children: [
          const Align(alignment: Alignment.centerLeft, child: MenuButton()),
          const SizedBox(height: 34),
          Text('식물 도감', style: Theme.of(context).textTheme.headlineLarge),
          const SizedBox(height: 28),
          TextField(
            onChanged: (value) => setState(() => _keyword = value),
            decoration: const InputDecoration(
              hintText: '검색',
              prefixIcon: Icon(Icons.search),
            ),
          ),
          const SizedBox(height: 48),
          ...guides.map(
            (guide) => Padding(
              padding: const EdgeInsets.only(bottom: 18),
              child: InkWell(
                borderRadius: BorderRadius.circular(18),
                onTap: () => Navigator.pushNamed(
                  context,
                  AppRoutes.encyclopediaEntry,
                  arguments: guide,
                ),
                child: SizedBox(
                  height: 94,
                  child: Row(
                    children: [
                      PrototypeImage(
                        asset: guide.imageAsset,
                        width: 94,
                        height: 94,
                        borderRadius: BorderRadius.circular(18),
                      ),
                      const Spacer(),
                      Flexible(
                        flex: 3,
                        child: Text(
                          guide.model.speciesName,
                          textAlign: TextAlign.right,
                          style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          if (guides.length < 4)
            const Padding(
              padding: EdgeInsets.only(top: 12),
              child: Row(
                children: [
                  CheckerBox(width: 96, height: 96),
                  Spacer(),
                  Text('식물종 이름', style: TextStyle(fontSize: 17)),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class EncyclopediaEntryScreen extends StatelessWidget {
  final DemoCareGuide guide;

  const EncyclopediaEntryScreen({super.key, required this.guide});

  @override
  Widget build(BuildContext context) {
    final model = guide.model;
    return Scaffold(
      appBar: AppBar(
        title: Text(model.speciesName),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const AssetIcon(name: 'back'),
        ),
      ),
      body: PrototypeScaffold(
        includeBottomSafeArea: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 40),
          children: [
            PrototypeImage(
              asset: guide.imageAsset,
              width: double.infinity,
              height: 340,
              borderRadius: BorderRadius.circular(24),
            ),
            const SizedBox(height: 24),
            Text(
              model.speciesName,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 8),
            Text(
              model.difficulty,
              style: const TextStyle(
                color: AppColors.subText,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 24),
            _InfoBlock(title: '햇빛', text: model.sunlight),
            _InfoBlock(title: '물', text: model.watering),
            if (model.fertilizer != null)
              _InfoBlock(title: '비료', text: model.fertilizer!),
            if (model.temperature != null)
              _InfoBlock(title: '온도', text: model.temperature!),
            if (model.toxicity != null)
              _InfoBlock(title: '주의사항', text: model.toxicity!),
            if (model.description != null)
              _InfoBlock(title: '설명', text: model.description!),
          ],
        ),
      ),
    );
  }
}

class _InfoBlock extends StatelessWidget {
  final String title;
  final String text;

  const _InfoBlock({required this.title, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: AppColors.subText,
              fontSize: 13,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          Text(text, style: Theme.of(context).textTheme.bodyLarge),
        ],
      ),
    );
  }
}
