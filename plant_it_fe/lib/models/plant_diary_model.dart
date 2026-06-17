class PlantDiaryModel {
  const PlantDiaryModel({
    required this.id,
    this.imageUrl,
    this.note,
    this.recordedAt,
    this.aiHealthSummary,
  });

  final int id;
  final String? imageUrl;
  final String? note;
  final DateTime? recordedAt;
  final String? aiHealthSummary;

  factory PlantDiaryModel.fromJson(Map<String, dynamic> json) {
    return PlantDiaryModel(
      id: (json['id'] as num?)?.toInt() ?? 0,
      imageUrl: json['imageUrl'] as String?,
      note: json['note'] as String?,
      recordedAt: json['recordedAt'] is String
          ? DateTime.tryParse(json['recordedAt'] as String)
          : null,
      aiHealthSummary: json['aiHealthSummary'] as String?,
    );
  }
}
