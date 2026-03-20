import '../model/plant_care_guide_model.dart';
import 'base_data_service.dart';

class PlantCareGuideDataService extends BaseDataService {
  PlantCareGuideDataService({super.client});

  Future<List<PlantCareGuideModel>> fetchGuides({
    String? accessToken,
    String? keyword,
    String? difficulty,
    String? sunlight,
  }) {
    return getList(
      '/api/v1/guide/plants',
      PlantCareGuideModel.fromJson,
      accessToken: accessToken,
      queryParameters: {
        'keyword': keyword,
        'difficulty': difficulty,
        'sunlight': sunlight,
      },
    );
  }

  Future<PlantCareGuideModel> fetchGuide(
    int guideId, {
    String? accessToken,
  }) {
    return getObject(
      '/api/v1/guide/plants/$guideId',
      PlantCareGuideModel.fromJson,
      accessToken: accessToken,
    );
  }
}
