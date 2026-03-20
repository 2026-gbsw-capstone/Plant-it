import 'dart:typed_data';

import 'package:http/http.dart' as http;

import '../data/model/presigned_upload_model.dart';
import '../data/service/file_data_service.dart';

class ImageUploadService {
  ImageUploadService({
    FileDataService? fileDataService,
    http.Client? client,
  }) : _fileDataService = fileDataService ?? FileDataService(),
       _client = client ?? http.Client();

  final FileDataService _fileDataService;
  final http.Client _client;

  Future<PresignedUploadModel> createUploadUrl({
    required String fileName,
    required String contentType,
    String? accessToken,
  }) {
    return _fileDataService.createPresignedUpload(
      fileName: fileName,
      contentType: contentType,
      accessToken: accessToken,
    );
  }

  Future<String> uploadBytes({
    required Uint8List bytes,
    required String fileName,
    required String contentType,
    String? accessToken,
  }) async {
    final presigned = await createUploadUrl(
      fileName: fileName,
      contentType: contentType,
      accessToken: accessToken,
    );

    final response = await _client.put(
      Uri.parse(presigned.uploadUrl),
      headers: {
        'Content-Type': contentType,
      },
      body: bytes,
    );

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception('Image upload failed with status ${response.statusCode}.');
    }

    return presigned.fileUrl;
  }
}
