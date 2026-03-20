import 'model_utils.dart';

enum PlantAnalysisType { speciesIdentification, healthAnalysis, chat }

extension PlantAnalysisTypeJson on PlantAnalysisType {
  static PlantAnalysisType fromJson(String value) {
    switch (value) {
      case 'SPECIES_IDENTIFICATION':
        return PlantAnalysisType.speciesIdentification;
      case 'HEALTH_ANALYSIS':
        return PlantAnalysisType.healthAnalysis;
      case 'CHAT':
        return PlantAnalysisType.chat;
      default:
        throw ArgumentError('Unknown analysisType: $value');
    }
  }

  String toJson() {
    switch (this) {
      case PlantAnalysisType.speciesIdentification:
        return 'SPECIES_IDENTIFICATION';
      case PlantAnalysisType.healthAnalysis:
        return 'HEALTH_ANALYSIS';
      case PlantAnalysisType.chat:
        return 'CHAT';
    }
  }
}

enum AnalysisResultStatus { success, failed }

extension AnalysisResultStatusJson on AnalysisResultStatus {
  static AnalysisResultStatus fromJson(String value) {
    switch (value) {
      case 'SUCCESS':
        return AnalysisResultStatus.success;
      case 'FAILED':
        return AnalysisResultStatus.failed;
      default:
        throw ArgumentError('Unknown resultStatus: $value');
    }
  }

  String toJson() {
    switch (this) {
      case AnalysisResultStatus.success:
        return 'SUCCESS';
      case AnalysisResultStatus.failed:
        return 'FAILED';
    }
  }
}

class PlantAiAnalysisModel {
  final int id;
  final int plantId;
  final int? diaryId;
  final String? imageUrl;
  final PlantAnalysisType analysisType;
  final String resultText;
  final AnalysisResultStatus resultStatus;
  final DateTime createdAt;

  const PlantAiAnalysisModel({
    required this.id,
    required this.plantId,
    this.diaryId,
    this.imageUrl,
    required this.analysisType,
    required this.resultText,
    required this.resultStatus,
    required this.createdAt,
  });

  factory PlantAiAnalysisModel.fromJson(Map<String, dynamic> json) {
    return PlantAiAnalysisModel(
      id: readInt(json, ['id'])!,
      plantId: readInt(json, ['plant_id', 'plantId'])!,
      diaryId: readInt(json, ['diary_id', 'diaryId']),
      imageUrl: readString(json, ['image_url', 'imageUrl']),
      analysisType: PlantAnalysisTypeJson.fromJson(
        readString(json, ['analysis_type', 'analysisType'])!,
      ),
      resultText: readString(json, ['result_text', 'resultText'])!,
      resultStatus: AnalysisResultStatusJson.fromJson(
        readString(json, ['result_status', 'resultStatus'])!,
      ),
      createdAt: readDateTime(json, ['created_at', 'createdAt'])!,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'plant_id': plantId,
      'diary_id': diaryId,
      'image_url': imageUrl,
      'analysis_type': analysisType.toJson(),
      'result_text': resultText,
      'result_status': resultStatus.toJson(),
      'created_at': writeDateTime(createdAt),
    };
  }
}
