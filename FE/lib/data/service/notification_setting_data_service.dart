import '../model/notification_setting_model.dart';
import 'base_data_service.dart';

class NotificationSettingDataService extends BaseDataService {
  NotificationSettingDataService({super.client});

  Future<List<NotificationSettingModel>> fetchSettings({String? accessToken}) {
    return getList(
      '/api/v1/notifications/settings',
      NotificationSettingModel.fromJson,
      accessToken: accessToken,
    );
  }

  Future<dynamic> updateSetting(
    Map<String, dynamic> payload, {
    String? accessToken,
  }) {
    return patchData(
      '/api/v1/notifications/settings',
      accessToken: accessToken,
      body: payload,
    );
  }

  Future<void> registerPushToken(
    String pushToken, {
    String? accessToken,
  }) async {
    await postData(
      '/api/v1/notifications/token',
      accessToken: accessToken,
      body: {
        'pushToken': pushToken,
      },
    );
  }
}
