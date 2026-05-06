enum AnalysisType {
  speciesIdentification('SPECIES_IDENTIFICATION'),
  healthAnalysis('HEALTH_ANALYSIS'),
  chat('CHAT');

  final String value;

  const AnalysisType(this.value);

  static AnalysisType fromJson(String? value) {
    return AnalysisType.values.firstWhere(
      (type) => type.value == value,
      orElse: () => AnalysisType.healthAnalysis,
    );
  }
}

enum AnalysisResultStatus {
  success('SUCCESS'),
  failed('FAILED');

  final String value;

  const AnalysisResultStatus(this.value);

  static AnalysisResultStatus fromJson(String? value) {
    return AnalysisResultStatus.values.firstWhere(
      (status) => status.value == value,
      orElse: () => AnalysisResultStatus.success,
    );
  }
}

class PlantAiAnalysisModel {
  final int id;
  final int plantId;
  final int? diaryId;
  final String? imageUrl;
  final AnalysisType analysisType;
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
      id: json['id'] as int,
      plantId: json['plantId'] as int,
      diaryId: json['diaryId'] as int?,
      imageUrl: json['imageUrl'] as String?,
      analysisType: AnalysisType.fromJson(json['analysisType'] as String?),
      resultText: json['resultText'] as String,
      resultStatus: AnalysisResultStatus.fromJson(
        json['resultStatus'] as String?,
      ),
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'plantId': plantId,
      'diaryId': diaryId,
      'imageUrl': imageUrl,
      'analysisType': analysisType.value,
      'resultText': resultText,
      'resultStatus': resultStatus.value,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}

class PlantIdentifyResultModel {
  final String speciesName;
  final double confidence;

  const PlantIdentifyResultModel({
    required this.speciesName,
    required this.confidence,
  });

  factory PlantIdentifyResultModel.fromJson(Map<String, dynamic> json) {
    return PlantIdentifyResultModel(
      speciesName: json['speciesName'] as String,
      confidence: (json['confidence'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {'speciesName': speciesName, 'confidence': confidence};
  }
}

class HealthCheckResultModel {
  final String healthStatus;
  final String summary;
  final List<String> tips;

  const HealthCheckResultModel({
    required this.healthStatus,
    required this.summary,
    required this.tips,
  });

  factory HealthCheckResultModel.fromJson(Map<String, dynamic> json) {
    return HealthCheckResultModel(
      healthStatus: json['healthStatus'] as String,
      summary: json['summary'] as String,
      tips: (json['tips'] as List<dynamic>? ?? [])
          .map((tip) => tip as String)
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {'healthStatus': healthStatus, 'summary': summary, 'tips': tips};
  }
}
