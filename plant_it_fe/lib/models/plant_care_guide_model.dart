class PlantCareGuideModel {
  const PlantCareGuideModel({
    required this.id,
    required this.speciesName,
    required this.difficulty,
    this.imageUrl,
    this.sunlight,
    this.watering,
    this.fertilizer,
    this.humidity,
    this.temperature,
    this.toxicity,
    this.description,
  });

  final int id;
  final String speciesName;
  final String difficulty;
  final String? imageUrl;
  final String? sunlight;
  final String? watering;
  final String? fertilizer;
  final String? humidity;
  final String? temperature;
  final String? toxicity;
  final String? description;

  factory PlantCareGuideModel.fromJson(Map<String, dynamic> json) {
    return PlantCareGuideModel(
      id: (json['id'] as num?)?.toInt() ?? 0,
      speciesName: json['speciesName'] as String? ?? '',
      difficulty: json['difficulty'] as String? ?? '',
      imageUrl: json['imageUrl'] as String?,
      sunlight: json['sunlight'] as String?,
      watering: json['watering'] as String?,
      fertilizer: json['fertilizer'] as String?,
      humidity: json['humidity'] as String?,
      temperature: json['temperature'] as String?,
      toxicity: json['toxicity'] as String?,
      description: json['description'] as String?,
    );
  }
}
