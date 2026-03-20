import 'model_utils.dart';

class AiChatResponseModel {
  final String answer;

  const AiChatResponseModel({required this.answer});

  factory AiChatResponseModel.fromJson(Map<String, dynamic> json) {
    return AiChatResponseModel(
      answer: readString(json, ['answer'])!,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'answer': answer,
    };
  }
}
