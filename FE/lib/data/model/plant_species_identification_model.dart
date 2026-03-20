import 'model_utils.dart';

class PlantSpeciesIdentificationModel {
  final String speciesName;
  final double confidence;

  const PlantSpeciesIdentificationModel({
    required this.speciesName,
    required this.confidence,
  });

  factory PlantSpeciesIdentificationModel.fromJson(Map<String, dynamic> json) {
    final rawConfidence = readJsonValue<dynamic>(json, ['confidence']);
    return PlantSpeciesIdentificationModel(
      speciesName: readString(json, ['speciesName', 'species_name'])!,
      confidence: rawConfidence is num
          ? rawConfidence.toDouble()
          : double.parse(rawConfidence.toString()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'species_name': speciesName,
      'confidence': confidence,
    };
  }
}
