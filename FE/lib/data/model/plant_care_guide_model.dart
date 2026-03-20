import 'model_utils.dart';

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
  final DateTime createdAt;
  final DateTime updatedAt;

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
    required this.createdAt,
    required this.updatedAt,
  });

  factory PlantCareGuideModel.fromJson(Map<String, dynamic> json) {
    return PlantCareGuideModel(
      id: readInt(json, ['id'])!,
      speciesName: readString(json, ['species_name', 'speciesName'])!,
      difficulty: readString(json, ['difficulty'])!,
      sunlight: readString(json, ['sunlight'])!,
      watering: readString(json, ['watering'])!,
      fertilizer: readString(json, ['fertilizer']),
      humidity: readString(json, ['humidity']),
      temperature: readString(json, ['temperature']),
      toxicity: readString(json, ['toxicity']),
      description: readString(json, ['description']),
      imageUrl: readString(json, ['image_url', 'imageUrl']),
      createdAt: readDateTime(json, ['created_at', 'createdAt'])!,
      updatedAt: readDateTime(json, ['updated_at', 'updatedAt'])!,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'species_name': speciesName,
      'difficulty': difficulty,
      'sunlight': sunlight,
      'watering': watering,
      'fertilizer': fertilizer,
      'humidity': humidity,
      'temperature': temperature,
      'toxicity': toxicity,
      'description': description,
      'image_url': imageUrl,
      'created_at': writeDateTime(createdAt),
      'updated_at': writeDateTime(updatedAt),
    };
  }
}
