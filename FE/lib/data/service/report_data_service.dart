import 'base_data_service.dart';

class ReportDataService extends BaseDataService {
  ReportDataService({super.client});

  Future<void> createReport(
    Map<String, dynamic> payload, {
    String? accessToken,
  }) async {
    await postData(
      '/api/v1/reports',
      accessToken: accessToken,
      body: payload,
    );
  }
}
