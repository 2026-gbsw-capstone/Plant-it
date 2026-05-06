import 'package:plant_it_fe/models/notification_setting_model.dart';
import 'package:plant_it_fe/models/plant_ai_analysis_model.dart';
import 'package:plant_it_fe/models/plant_care_guide_model.dart';
import 'package:plant_it_fe/models/plant_diary_model.dart';
import 'package:plant_it_fe/models/plant_model.dart';
import 'package:plant_it_fe/models/user_model.dart';

class DemoPlant {
  final PlantModel model;
  final String imageAsset;
  final bool needsWater;
  final bool needsFertilizer;

  const DemoPlant({
    required this.model,
    required this.imageAsset,
    this.needsWater = false,
    this.needsFertilizer = false,
  });
}

class DemoCareGuide {
  final PlantCareGuideModel model;
  final String imageAsset;

  const DemoCareGuide({required this.model, required this.imageAsset});
}

final demoUser = UserModel(
  id: 1,
  email: 'plant@example.com',
  nickname: '사용자',
  profileImageUrl: null,
  loginType: LoginType.email,
  createdAt: DateTime(2026, 4, 22, 10),
  updatedAt: DateTime(2026, 4, 23, 10),
);

final demoPlants = [
  DemoPlant(
    model: PlantModel(
      id: 1,
      name: '몬스테라',
      speciesName: '델리시오사',
      plantImageUrl: 'assets/images/demo/monstera.png',
      wateringCycleDays: 7,
      fertilizerCycleDays: 30,
      registeredAt: DateTime(2026, 3, 2),
      lastWateredAt: DateTime(2026, 4, 20),
      lastFertilizedAt: DateTime(2026, 4, 1),
      nextWateringDate: DateTime(2026, 4, 24),
      healthStatus: HealthStatus.good,
      memo: '창가 가까이 두고 흙 표면이 마르면 물을 주세요.',
    ),
    imageAsset: 'assets/images/demo/monstera.png',
    needsFertilizer: true,
  ),
  DemoPlant(
    model: PlantModel(
      id: 2,
      name: '선인장',
      speciesName: '마밀라리아',
      plantImageUrl: 'assets/images/demo/cactus.png',
      wateringCycleDays: 14,
      fertilizerCycleDays: 45,
      registeredAt: DateTime(2026, 3, 12),
      lastWateredAt: DateTime(2026, 4, 9),
      lastFertilizedAt: DateTime(2026, 3, 9),
      nextWateringDate: DateTime(2026, 4, 23),
      healthStatus: HealthStatus.warning,
      memo: '물은 손가락으로 찔러봐서 완전히 건조할 때 주세요.',
    ),
    imageAsset: 'assets/images/demo/cactus.png',
    needsWater: true,
    needsFertilizer: true,
  ),
  DemoPlant(
    model: PlantModel(
      id: 3,
      name: '호야',
      speciesName: '호야 카르노사',
      plantImageUrl: 'assets/images/demo/hoya.png',
      wateringCycleDays: 9,
      fertilizerCycleDays: 30,
      registeredAt: DateTime(2026, 4, 4),
      nextWateringDate: DateTime(2026, 4, 28),
      healthStatus: HealthStatus.good,
      memo: '과습을 피하고 밝은 간접광을 유지하세요.',
    ),
    imageAsset: 'assets/images/demo/hoya.png',
    needsFertilizer: true,
  ),
  DemoPlant(
    model: PlantModel(
      id: 4,
      name: '테이블 야자',
      speciesName: 'Chamaedorea elegans',
      plantImageUrl: 'assets/images/demo/table_palm.png',
      wateringCycleDays: 5,
      fertilizerCycleDays: 20,
      registeredAt: DateTime(2026, 4, 10),
      nextWateringDate: DateTime(2026, 4, 25),
      healthStatus: HealthStatus.good,
      memo: '건조하면 잎 끝이 마를 수 있어 분무해 주세요.',
    ),
    imageAsset: 'assets/images/demo/table_palm.png',
  ),
  DemoPlant(
    model: PlantModel(
      id: 5,
      name: '이름',
      speciesName: '무늬 잎',
      plantImageUrl: 'assets/images/demo/leaf.png',
      wateringCycleDays: 7,
      fertilizerCycleDays: 30,
      registeredAt: DateTime(2026, 4, 12),
      nextWateringDate: DateTime(2026, 4, 26),
      healthStatus: HealthStatus.good,
      memo: '새로 등록한 식물입니다.',
    ),
    imageAsset: 'assets/images/demo/leaf.png',
  ),
];

final demoCareGuides = [
  DemoCareGuide(
    model: PlantCareGuideModel(
      id: 1,
      speciesName: '마밀라리아',
      difficulty: 'EASY',
      sunlight: '하루 4-6시간의 밝은 직사광선을 좋아합니다.',
      watering: '흙이 완전히 건조한 상태일 때 물을 주세요.',
      fertilizer: '봄과 여름에 한 번씩 희석한 비료를 주세요.',
      humidity: '건조한 환경을 선호합니다.',
      temperature: '18-30°C',
      toxicity: '가시가 있어 반려동물과 아이를 주의하세요.',
      description: '작은 구형 줄기와 꽃이 특징인 선인장입니다.',
      imageUrl: 'assets/images/demo/guide_mammillaria.png',
    ),
    imageAsset: 'assets/images/demo/guide_mammillaria.png',
  ),
  DemoCareGuide(
    model: PlantCareGuideModel(
      id: 2,
      speciesName: '용각볼 파리지옥',
      difficulty: 'MEDIUM',
      sunlight: '밝은 빛을 충분히 받는 곳이 좋습니다.',
      watering: '항상 촉촉하게 유지하되 고인 물은 피하세요.',
      description: '독특한 포충엽이 돋보이는 식충식물입니다.',
      imageUrl: 'assets/images/demo/guide_parrot.png',
    ),
    imageAsset: 'assets/images/demo/guide_parrot.png',
  ),
  DemoCareGuide(
    model: PlantCareGuideModel(
      id: 3,
      speciesName: '사시그리아 데 알티모 모스 라 라테',
      difficulty: 'HARD',
      sunlight: '반그늘 환경에 적응합니다.',
      watering: '표면이 마르면 촉촉하게 주세요.',
      description: '습도 관리가 중요한 관상 식물입니다.',
      imageUrl: 'assets/images/demo/guide_moss.png',
    ),
    imageAsset: 'assets/images/demo/guide_moss.png',
  ),
];

final demoDiaries = [
  PlantDiaryModel(
    id: 1,
    plantId: 2,
    imageUrl: 'assets/images/demo/cactus.png',
    note: '꽃이 폈다.',
    recordedAt: DateTime(2026, 4, 20, 8, 30),
    aiHealthSummary: '전반적으로 건강한 상태입니다.',
  ),
  PlantDiaryModel(
    id: 2,
    plantId: 2,
    imageUrl: 'assets/images/demo/guide_mammillaria.png',
    note: '가시 주변이 단단하다.',
    recordedAt: DateTime(2026, 4, 21, 9),
    aiHealthSummary: '과습 징후는 낮습니다.',
  ),
];

final demoAnalysis = PlantAiAnalysisModel(
  id: 1,
  plantId: 2,
  imageUrl: 'assets/images/demo/cactus.png',
  analysisType: AnalysisType.healthAnalysis,
  resultText: '잎 끝 갈변은 과습 또는 통풍 부족일 수 있습니다.',
  resultStatus: AnalysisResultStatus.success,
  createdAt: DateTime(2026, 4, 23, 9),
);

final demoNotificationSettings = [
  NotificationSettingModel(
    id: 1,
    userId: 1,
    plantId: 2,
    wateringEnabled: true,
    fertilizerEnabled: true,
    growthRecordEnabled: true,
  ),
];
