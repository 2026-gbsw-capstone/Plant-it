enum HealthStatus {
  good('GOOD'),
  warning('WARNING'),
  danger('DANGER');

  final String value;

  const HealthStatus(this.value);

  static HealthStatus fromJson(String? value) {
    return HealthStatus.values.firstWhere(
      (status) => status.value == value,
      orElse: () => HealthStatus.good,
    );
  }
}

class PlantModel {
  final int id;
  final String name;
  final String? speciesName;
  final String? plantImageUrl;
  final int? wateringCycleDays;
  final int? fertilizerCycleDays;
  final DateTime? registeredAt;
  final DateTime? lastWateredAt;
  final DateTime? lastFertilizedAt;
  final DateTime? nextWateringDate;
  final HealthStatus healthStatus;
  final String? memo;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const PlantModel({
    required this.id,
    required this.name,
    this.speciesName,
    this.plantImageUrl,
    this.wateringCycleDays,
    this.fertilizerCycleDays,
    this.registeredAt,
    this.lastWateredAt,
    this.lastFertilizedAt,
    this.nextWateringDate,
    this.healthStatus = HealthStatus.good,
    this.memo,
    this.createdAt,
    this.updatedAt,
  });

  factory PlantModel.fromJson(Map<String, dynamic> json) {
    return PlantModel(
      id: json['id'] as int,
      name: json['name'] as String,
      speciesName: json['speciesName'] as String?,
      plantImageUrl: json['plantImageUrl'] as String?,
      wateringCycleDays: json['wateringCycleDays'] as int?,
      fertilizerCycleDays: json['fertilizerCycleDays'] as int?,
      registeredAt: _dateTimeOrNull(json['registeredAt']),
      lastWateredAt: _dateTimeOrNull(json['lastWateredAt']),
      lastFertilizedAt: _dateTimeOrNull(json['lastFertilizedAt']),
      nextWateringDate: _dateTimeOrNull(json['nextWateringDate']),
      healthStatus: HealthStatus.fromJson(json['healthStatus'] as String?),
      memo: json['memo'] as String?,
      createdAt: _dateTimeOrNull(json['createdAt']),
      updatedAt: _dateTimeOrNull(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'speciesName': speciesName,
      'plantImageUrl': plantImageUrl,
      'wateringCycleDays': wateringCycleDays,
      'fertilizerCycleDays': fertilizerCycleDays,
      'registeredAt': registeredAt?.toIso8601String(),
      'lastWateredAt': lastWateredAt?.toIso8601String(),
      'lastFertilizedAt': lastFertilizedAt?.toIso8601String(),
      'nextWateringDate': nextWateringDate?.toIso8601String(),
      'healthStatus': healthStatus.value,
      'memo': memo,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }
}

DateTime? _dateTimeOrNull(Object? value) {
  if (value == null) return null;
  return DateTime.tryParse(value as String);
}
