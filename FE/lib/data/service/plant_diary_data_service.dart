import '../model/plant_diary_model.dart';
import 'base_data_service.dart';

class PlantDiaryDataService extends BaseDataService {
  PlantDiaryDataService({super.client});

  Future<int?> createDiary(
    int plantId,
    Map<String, dynamic> payload, {
    String? accessToken,
  }) async {
    final data = await postData(
      '/api/v1/plants/$plantId/diaries',
      accessToken: accessToken,
      body: payload,
    );
    return (data as Map<String, dynamic>)['diaryId'] as int?;
  }

  Future<List<PlantDiaryModel>> fetchDiaries(
    int plantId, {
    String? accessToken,
  }) {
    return getList(
      '/api/v1/plants/$plantId/diaries',
      PlantDiaryModel.fromJson,
      accessToken: accessToken,
    );
  }

  Future<PlantDiaryModel> fetchDiary(
    int plantId,
    int diaryId, {
    String? accessToken,
  }) {
    return getObject(
      '/api/v1/plants/$plantId/diaries/$diaryId',
      PlantDiaryModel.fromJson,
      accessToken: accessToken,
    );
  }

  Future<dynamic> updateDiary(
    int plantId,
    int diaryId,
    Map<String, dynamic> payload, {
    String? accessToken,
  }) {
    return patchData(
      '/api/v1/plants/$plantId/diaries/$diaryId',
      accessToken: accessToken,
      body: payload,
    );
  }

  Future<void> deleteDiary(
    int plantId,
    int diaryId, {
    String? accessToken,
  }) async {
    await deleteData(
      '/api/v1/plants/$plantId/diaries/$diaryId',
      accessToken: accessToken,
    );
  }
}
