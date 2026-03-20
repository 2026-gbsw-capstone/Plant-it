import 'model_utils.dart';

class NotificationSettingModel {
  final int id;
  final int userId;
  final int? plantId;
  final bool wateringEnabled;
  final bool fertilizerEnabled;
  final bool growthRecordEnabled;
  final String? pushToken;
  final DateTime createdAt;
  final DateTime updatedAt;

  const NotificationSettingModel({
    required this.id,
    required this.userId,
    this.plantId,
    required this.wateringEnabled,
    required this.fertilizerEnabled,
    required this.growthRecordEnabled,
    this.pushToken,
    required this.createdAt,
    required this.updatedAt,
  });

  factory NotificationSettingModel.fromJson(Map<String, dynamic> json) {
    return NotificationSettingModel(
      id: readInt(json, ['id'])!,
      userId: readInt(json, ['user_id', 'userId'])!,
      plantId: readInt(json, ['plant_id', 'plantId']),
      wateringEnabled: readBool(
        json,
        ['watering_enabled', 'wateringEnabled'],
      )!,
      fertilizerEnabled: readBool(
        json,
        ['fertilizer_enabled', 'fertilizerEnabled'],
      )!,
      growthRecordEnabled: readBool(
        json,
        ['growth_record_enabled', 'growthRecordEnabled'],
      )!,
      pushToken: readString(json, ['push_token', 'pushToken']),
      createdAt: readDateTime(json, ['created_at', 'createdAt'])!,
      updatedAt: readDateTime(json, ['updated_at', 'updatedAt'])!,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'plant_id': plantId,
      'watering_enabled': wateringEnabled,
      'fertilizer_enabled': fertilizerEnabled,
      'growth_record_enabled': growthRecordEnabled,
      'push_token': pushToken,
      'created_at': writeDateTime(createdAt),
      'updated_at': writeDateTime(updatedAt),
    };
  }
}
