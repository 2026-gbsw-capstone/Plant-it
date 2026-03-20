import 'model_utils.dart';

class PresignedUploadModel {
  final String uploadUrl;
  final String fileUrl;

  const PresignedUploadModel({
    required this.uploadUrl,
    required this.fileUrl,
  });

  factory PresignedUploadModel.fromJson(Map<String, dynamic> json) {
    return PresignedUploadModel(
      uploadUrl: readString(json, ['uploadUrl', 'upload_url'])!,
      fileUrl: readString(json, ['fileUrl', 'file_url'])!,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'upload_url': uploadUrl,
      'file_url': fileUrl,
    };
  }
}
