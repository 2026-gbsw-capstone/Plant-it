class NotificationSettingModel {
  final int? id;
  final int? userId;
  final int? plantId;
  final bool wateringEnabled;
  final bool fertilizerEnabled;
  final bool growthRecordEnabled;
  final String? pushToken;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const NotificationSettingModel({
    this.id,
    this.userId,
    this.plantId,
    required this.wateringEnabled,
    required this.fertilizerEnabled,
    required this.growthRecordEnabled,
    this.pushToken,
    this.createdAt,
    this.updatedAt,
  });

  factory NotificationSettingModel.fromJson(Map<String, dynamic> json) {
    return NotificationSettingModel(
      id: json['id'] as int?,
      userId: json['userId'] as int?,
      plantId: json['plantId'] as int?,
      wateringEnabled: json['wateringEnabled'] as bool? ?? true,
      fertilizerEnabled: json['fertilizerEnabled'] as bool? ?? true,
      growthRecordEnabled: json['growthRecordEnabled'] as bool? ?? true,
      pushToken: json['pushToken'] as String?,
      createdAt: _dateTimeOrNull(json['createdAt']),
      updatedAt: _dateTimeOrNull(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'plantId': plantId,
      'wateringEnabled': wateringEnabled,
      'fertilizerEnabled': fertilizerEnabled,
      'growthRecordEnabled': growthRecordEnabled,
      'pushToken': pushToken,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }
}

DateTime? _dateTimeOrNull(Object? value) {
  if (value == null) return null;
  return DateTime.tryParse(value as String);
}
