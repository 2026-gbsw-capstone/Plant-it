import 'model_utils.dart';
import 'plant_model.dart';

class PlantHealthCheckResultModel {
  final HealthStatus healthStatus;
  final String summary;
  final List<String> tips;

  const PlantHealthCheckResultModel({
    required this.healthStatus,
    required this.summary,
    required this.tips,
  });

  factory PlantHealthCheckResultModel.fromJson(Map<String, dynamic> json) {
    final tipsValue = readJsonValue<dynamic>(json, ['tips']);
    return PlantHealthCheckResultModel(
      healthStatus: HealthStatusJson.fromJson(
        readString(json, ['healthStatus', 'health_status'])!,
      ),
      summary: readString(json, ['summary'])!,
      tips: tipsValue is List ? tipsValue.map((e) => e.toString()).toList() : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'health_status': healthStatus.toJson(),
      'summary': summary,
      'tips': tips,
    };
  }
}
