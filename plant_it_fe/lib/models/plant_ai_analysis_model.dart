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
