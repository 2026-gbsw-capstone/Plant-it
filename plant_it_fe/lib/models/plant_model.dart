class PlantModel {
  const PlantModel({
    required this.id,
    required this.name,
    this.speciesName,
    this.plantImageUrl,
    this.healthStatus = PlantHealthStatus.good,
    this.nextWateringDate,
    this.wateringCycleDays,
    this.fertilizerCycleDays,
    this.lastWateredAt,
    this.lastFertilizedAt,
    this.memo,
    this.registeredAt,
  });

  final int id;
  final String name;
  final String? speciesName;
  final String? plantImageUrl;
  final PlantHealthStatus healthStatus;
  final DateTime? nextWateringDate;
  final int? wateringCycleDays;
  final int? fertilizerCycleDays;
  final DateTime? lastWateredAt;
  final DateTime? lastFertilizedAt;
  final String? memo;
  final DateTime? registeredAt;

  factory PlantModel.fromJson(Map<String, dynamic> json) {
    return PlantModel(
      id: (json['id'] as num?)?.toInt() ?? 0,
      name: json['name'] as String? ?? '',
      speciesName: json['speciesName'] as String?,
      plantImageUrl: json['plantImageUrl'] as String?,
      healthStatus: PlantHealthStatus.fromJson(json['healthStatus'] as String?),
      nextWateringDate: _parseDate(json['nextWateringDate']),
      wateringCycleDays: (json['wateringCycleDays'] as num?)?.toInt(),
      fertilizerCycleDays: (json['fertilizerCycleDays'] as num?)?.toInt(),
      lastWateredAt: _parseDate(json['lastWateredAt']),
      lastFertilizedAt: _parseDate(json['lastFertilizedAt']),
      memo: json['memo'] as String?,
      registeredAt: _parseDate(json['registeredAt']),
    );
  }

  String get speciesLabel {
    final value = speciesName?.trim();
    return value == null || value.isEmpty ? '품종 미등록' : value;
  }

  String get wateringLabel {
    if (nextWateringDate == null) return '미정';
    final today = DateTime.now();
    final diff = DateTime(
      nextWateringDate!.year,
      nextWateringDate!.month,
      nextWateringDate!.day,
    ).difference(DateTime(today.year, today.month, today.day)).inDays;
    if (diff == 0) return '오늘';
    if (diff == 1) return '내일';
    if (diff < 0) return '${diff.abs()}일 지남';
    return '$diff일 후';
  }

  static DateTime? _parseDate(dynamic value) {
    if (value == null) return null;
    if (value is String && value.isNotEmpty) return DateTime.tryParse(value);
    return null;
  }
}

enum PlantHealthStatus {
  good,
  warning,
  danger;

  static PlantHealthStatus fromJson(String? value) {
    switch (value) {
      case 'WARNING':
        return PlantHealthStatus.warning;
      case 'DANGER':
        return PlantHealthStatus.danger;
      case 'GOOD':
      default:
        return PlantHealthStatus.good;
    }
  }

  String get label {
    switch (this) {
      case PlantHealthStatus.good:
        return '좋음';
      case PlantHealthStatus.warning:
        return '주의';
      case PlantHealthStatus.danger:
        return '위험';
    }
  }
}
