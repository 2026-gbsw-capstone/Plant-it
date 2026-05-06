class PlantDiaryModel {
  final int id;
  final int? plantId;
  final String? imageUrl;
  final String? note;
  final DateTime recordedAt;
  final String? aiHealthSummary;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const PlantDiaryModel({
    required this.id,
    this.plantId,
    this.imageUrl,
    this.note,
    required this.recordedAt,
    this.aiHealthSummary,
    this.createdAt,
    this.updatedAt,
  });

  factory PlantDiaryModel.fromJson(Map<String, dynamic> json) {
    return PlantDiaryModel(
      id: json['id'] as int,
      plantId: json['plantId'] as int?,
      imageUrl: json['imageUrl'] as String?,
      note: json['note'] as String?,
      recordedAt: DateTime.parse(json['recordedAt'] as String),
      aiHealthSummary: json['aiHealthSummary'] as String?,
      createdAt: _dateTimeOrNull(json['createdAt']),
      updatedAt: _dateTimeOrNull(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'plantId': plantId,
      'imageUrl': imageUrl,
      'note': note,
      'recordedAt': recordedAt.toIso8601String(),
      'aiHealthSummary': aiHealthSummary,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }
}

DateTime? _dateTimeOrNull(Object? value) {
  if (value == null) return null;
  return DateTime.tryParse(value as String);
}
