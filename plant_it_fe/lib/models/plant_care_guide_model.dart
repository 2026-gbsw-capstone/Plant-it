class PlantCareGuideModel {
  final int id;
  final String speciesName;
  final String difficulty;
  final String sunlight;
  final String watering;
  final String? fertilizer;
  final String? humidity;
  final String? temperature;
  final String? toxicity;
  final String? description;
  final String? imageUrl;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const PlantCareGuideModel({
    required this.id,
    required this.speciesName,
    required this.difficulty,
    required this.sunlight,
    required this.watering,
    this.fertilizer,
    this.humidity,
    this.temperature,
    this.toxicity,
    this.description,
    this.imageUrl,
    this.createdAt,
    this.updatedAt,
  });

  factory PlantCareGuideModel.fromJson(Map<String, dynamic> json) {
    return PlantCareGuideModel(
      id: json['id'] as int,
      speciesName: json['speciesName'] as String,
      difficulty: json['difficulty'] as String,
      sunlight: json['sunlight'] as String? ?? '',
      watering: json['watering'] as String? ?? '',
      fertilizer: json['fertilizer'] as String?,
      humidity: json['humidity'] as String?,
      temperature: json['temperature'] as String?,
      toxicity: json['toxicity'] as String?,
      description: json['description'] as String?,
      imageUrl: json['imageUrl'] as String?,
      createdAt: _dateTimeOrNull(json['createdAt']),
      updatedAt: _dateTimeOrNull(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'speciesName': speciesName,
      'difficulty': difficulty,
      'sunlight': sunlight,
      'watering': watering,
      'fertilizer': fertilizer,
      'humidity': humidity,
      'temperature': temperature,
      'toxicity': toxicity,
      'description': description,
      'imageUrl': imageUrl,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }
}

DateTime? _dateTimeOrNull(Object? value) {
  if (value == null) return null;
  return DateTime.tryParse(value as String);
}
