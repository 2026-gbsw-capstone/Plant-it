import '../model/ai_chat_response_model.dart';
import '../model/plant_ai_analysis_model.dart';
import '../model/plant_health_check_result_model.dart';
import '../model/plant_species_identification_model.dart';
import 'base_data_service.dart';

class PlantAiAnalysisDataService extends BaseDataService {
  PlantAiAnalysisDataService({super.client});

  Future<PlantSpeciesIdentificationModel> identifySpecies(
    String imageUrl, {
    String? accessToken,
  }) {
    return postObject(
      '/api/v1/ai/plants/identify',
      PlantSpeciesIdentificationModel.fromJson,
      accessToken: accessToken,
      body: {
        'imageUrl': imageUrl,
      },
    );
  }

  Future<PlantHealthCheckResultModel> healthCheck(
    int plantId,
    String imageUrl, {
    String? accessToken,
  }) {
    return postObject(
      '/api/v1/ai/plants/health-check',
      PlantHealthCheckResultModel.fromJson,
      accessToken: accessToken,
      body: {
        'plantId': plantId,
        'imageUrl': imageUrl,
      },
    );
  }

  Future<AiChatResponseModel> askChat(
    int plantId,
    String question, {
    String? accessToken,
  }) {
    return postObject(
      '/api/v1/ai/chat',
      AiChatResponseModel.fromJson,
      accessToken: accessToken,
      body: {
        'plantId': plantId,
        'question': question,
      },
    );
  }

  Future<List<PlantAiAnalysisModel>> fetchAnalyses(
    int plantId, {
    String? accessToken,
  }) {
    return getList(
      '/api/v1/plants/$plantId/ai-analyses',
      PlantAiAnalysisModel.fromJson,
      accessToken: accessToken,
    );
  }
}
