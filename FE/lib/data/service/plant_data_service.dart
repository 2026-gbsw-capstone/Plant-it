import '../model/plant_model.dart';
import 'base_data_service.dart';

class PlantDataService extends BaseDataService {
  PlantDataService({super.client});

  Future<int?> createPlant(
    Map<String, dynamic> payload, {
    String? accessToken,
  }) async {
    final data = await postData(
      '/api/v1/plants',
      accessToken: accessToken,
      body: payload,
    );
    return (data as Map<String, dynamic>)['plantId'] as int?;
  }

  Future<List<PlantModel>> fetchPlants({String? accessToken}) {
    return getList(
      '/api/v1/plants',
      PlantModel.fromJson,
      accessToken: accessToken,
    );
  }

  Future<PlantModel> fetchPlant(
    int plantId, {
    String? accessToken,
  }) {
    return getObject(
      '/api/v1/plants/$plantId',
      PlantModel.fromJson,
      accessToken: accessToken,
    );
  }

  Future<dynamic> updatePlant(
    int plantId,
    Map<String, dynamic> payload, {
    String? accessToken,
  }) {
    return patchData(
      '/api/v1/plants/$plantId',
      accessToken: accessToken,
      body: payload,
    );
  }

  Future<void> deletePlant(
    int plantId, {
    String? accessToken,
  }) async {
    await deleteData('/api/v1/plants/$plantId', accessToken: accessToken);
  }

  Future<void> saveWaterRecord(
    int plantId,
    DateTime wateredAt, {
    String? accessToken,
  }) async {
    await postData(
      '/api/v1/plants/$plantId/water',
      accessToken: accessToken,
      body: {
        'wateredAt': wateredAt.toIso8601String(),
      },
    );
  }

  Future<void> saveFertilizerRecord(
    int plantId,
    DateTime fertilizedAt, {
    String? accessToken,
  }) async {
    await postData(
      '/api/v1/plants/$plantId/fertilizer',
      accessToken: accessToken,
      body: {
        'fertilizedAt': fertilizedAt.toIso8601String(),
      },
    );
  }
}
