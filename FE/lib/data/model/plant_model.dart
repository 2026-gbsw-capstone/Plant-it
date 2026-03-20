import 'model_utils.dart';

enum HealthStatus { good, warning, danger }

extension HealthStatusJson on HealthStatus {
  static HealthStatus fromJson(String value) {
    switch (value) {
      case 'GOOD':
        return HealthStatus.good;
      case 'WARNING':
        return HealthStatus.warning;
      case 'DANGER':
        return HealthStatus.danger;
      default:
        throw ArgumentError('Unknown healthStatus: $value');
    }
  }

  String toJson() {
    switch (this) {
      case HealthStatus.good:
        return 'GOOD';
      case HealthStatus.warning:
        return 'WARNING';
      case HealthStatus.danger:
        return 'DANGER';
    }
  }
}

class PlantModel {
  final int id;
  final int userId;
  final String name;
  final String? speciesName;
  final String? plantImageUrl;
  final DateTime registeredAt;
  final DateTime? lastWateredAt;
  final DateTime? lastFertilizedAt;
  final int? wateringCycleDays;
  final int? fertilizerCycleDays;
  final HealthStatus healthStatus;
  final String? memo;
  final DateTime createdAt;
  final DateTime updatedAt;

  const PlantModel({
    required this.id,
    required this.userId,
    required this.name,
    this.speciesName,
    this.plantImageUrl,
    required this.registeredAt,
    this.lastWateredAt,
    this.lastFertilizedAt,
    this.wateringCycleDays,
    this.fertilizerCycleDays,
    required this.healthStatus,
    this.memo,
    required this.createdAt,
    required this.updatedAt,
  });

  factory PlantModel.fromJson(Map<String, dynamic> json) {
    return PlantModel(
      id: readInt(json, ['id'])!,
      userId: readInt(json, ['user_id', 'userId'])!,
      name: readString(json, ['name'])!,
      speciesName: readString(json, ['species_name', 'speciesName']),
      plantImageUrl: readString(json, ['plant_image_url', 'plantImageUrl']),
      registeredAt: readDateTime(json, ['registered_at', 'registeredAt'])!,
      lastWateredAt: readDateTime(json, ['last_watered_at', 'lastWateredAt']),
      lastFertilizedAt: readDateTime(json, [
        'last_fertilized_at',
        'lastFertilizedAt',
      ]),
      wateringCycleDays: readInt(json, [
        'watering_cycle_days',
        'wateringCycleDays',
      ]),
      fertilizerCycleDays: readInt(json, [
        'fertilizer_cycle_days',
        'fertilizerCycleDays',
      ]),
      healthStatus: HealthStatusJson.fromJson(
        readString(json, ['health_status', 'healthStatus'])!,
      ),
      memo: readString(json, ['memo']),
      createdAt: readDateTime(json, ['created_at', 'createdAt'])!,
      updatedAt: readDateTime(json, ['updated_at', 'updatedAt'])!,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'name': name,
      'species_name': speciesName,
      'plant_image_url': plantImageUrl,
      'registered_at': writeDateTime(registeredAt),
      'last_watered_at': writeDateTime(lastWateredAt),
      'last_fertilized_at': writeDateTime(lastFertilizedAt),
      'watering_cycle_days': wateringCycleDays,
      'fertilizer_cycle_days': fertilizerCycleDays,
      'health_status': healthStatus.toJson(),
      'memo': memo,
      'created_at': writeDateTime(createdAt),
      'updated_at': writeDateTime(updatedAt),
    };
  }
}
