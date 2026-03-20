import 'model_utils.dart';

class IdResponseModel {
  final int id;

  const IdResponseModel({required this.id});

  factory IdResponseModel.fromJson(
    Map<String, dynamic> json, {
    List<String> keys = const ['id'],
  }) {
    return IdResponseModel(
      id: readInt(json, keys)!,
    );
  }
}
