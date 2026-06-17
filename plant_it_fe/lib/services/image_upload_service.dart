import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:plant_it_fe/services/api_service.dart';

class ImageUploadService {
  ImageUploadService._();

  static final instance = ImageUploadService._();

  final ImagePicker _picker = ImagePicker();

  Future<String?> pickPlantImage(ImageSource source) async {
    final file = await _picker.pickImage(
      source: source,
      maxWidth: 1600,
      maxHeight: 1600,
      imageQuality: 88,
    );
    return file?.path;
  }

  Future<String?> pickPlantImageFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: const ['jpg', 'jpeg', 'png', 'webp', 'heic', 'heif'],
      allowMultiple: false,
      withData: false,
    );
    return result?.files.single.path;
  }

  Future<String?> uploadIfLocalFile(
    String? value, {
    required String type,
  }) async {
    final path = value?.trim();
    if (path == null || path.isEmpty) return null;

    final uri = Uri.tryParse(path);
    final isRemote =
        uri?.hasScheme == true &&
        (uri!.scheme == 'http' || uri.scheme == 'https');
    if (isRemote) return path;

    final file = File(path);
    if (!await file.exists()) return path;

    return ApiService.instance.uploadImageFile(filePath: path, type: type);
  }
}
