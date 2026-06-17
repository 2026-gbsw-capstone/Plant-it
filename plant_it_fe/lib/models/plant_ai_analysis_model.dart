class ChatResponseModel {
  const ChatResponseModel({required this.answer});

  final String answer;

  factory ChatResponseModel.fromJson(Map<String, dynamic> json) {
    return ChatResponseModel(answer: json['answer'] as String? ?? '');
  }
}

class HealthCheckResponseModel {
  const HealthCheckResponseModel({
    required this.healthStatus,
    required this.summary,
    required this.tips,
  });

  final String healthStatus;
  final String summary;
  final List<String> tips;

  factory HealthCheckResponseModel.fromJson(Map<String, dynamic> json) {
    return HealthCheckResponseModel(
      healthStatus: json['healthStatus'] as String? ?? 'GOOD',
      summary: json['summary'] as String? ?? '',
      tips: (json['tips'] as List<dynamic>? ?? const [])
          .map((tip) => tip.toString())
          .toList(),
    );
  }
}

class IdentifyPlantResponseModel {
  const IdentifyPlantResponseModel({
    required this.speciesName,
    required this.confidence,
  });

  final String speciesName;
  final double confidence;

  factory IdentifyPlantResponseModel.fromJson(Map<String, dynamic> json) {
    return IdentifyPlantResponseModel(
      speciesName: json['speciesName'] as String? ?? '',
      confidence: (json['confidence'] as num?)?.toDouble() ?? 0,
    );
  }
}
