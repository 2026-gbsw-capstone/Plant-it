import 'model_utils.dart';

class PlantDiaryModel {
  final int id;
  final int plantId;
  final String? imageUrl;
  final String? note;
  final DateTime recordedAt;
  final String? aiHealthSummary;
  final DateTime createdAt;
  final DateTime updatedAt;

  const PlantDiaryModel({
    required this.id,
    required this.plantId,
    this.imageUrl,
    this.note,
    required this.recordedAt,
    this.aiHealthSummary,
    required this.createdAt,
    required this.updatedAt,
  });

  factory PlantDiaryModel.fromJson(Map<String, dynamic> json) {
    return PlantDiaryModel(
      id: readInt(json, ['id'])!,
      plantId: readInt(json, ['plant_id', 'plantId'])!,
      imageUrl: readString(json, ['image_url', 'imageUrl']),
      note: readString(json, ['note']),
      recordedAt: readDateTime(json, ['recorded_at', 'recordedAt'])!,
      aiHealthSummary: readString(
        json,
        ['ai_health_summary', 'aiHealthSummary'],
      ),
      createdAt: readDateTime(json, ['created_at', 'createdAt'])!,
      updatedAt: readDateTime(json, ['updated_at', 'updatedAt'])!,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'plant_id': plantId,
      'image_url': imageUrl,
      'note': note,
      'recorded_at': writeDateTime(recordedAt),
      'ai_health_summary': aiHealthSummary,
      'created_at': writeDateTime(createdAt),
      'updated_at': writeDateTime(updatedAt),
    };
  }
}
