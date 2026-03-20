import '../model/presigned_upload_model.dart';
import 'base_data_service.dart';

class FileDataService extends BaseDataService {
  FileDataService({super.client});

  Future<PresignedUploadModel> createPresignedUpload({
    required String fileName,
    required String contentType,
    String? accessToken,
  }) {
    return postObject(
      '/api/v1/files/presigned-url',
      PresignedUploadModel.fromJson,
      accessToken: accessToken,
      body: {
        'fileName': fileName,
        'contentType': contentType,
      },
    );
  }
}
