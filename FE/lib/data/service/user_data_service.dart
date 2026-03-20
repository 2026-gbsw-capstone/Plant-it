import '../model/user_model.dart';
import 'base_data_service.dart';

class UserDataService extends BaseDataService {
  UserDataService({super.client});

  Future<UserModel> fetchMe({String? accessToken}) {
    return getObject(
      '/api/v1/users/me',
      UserModel.fromJson,
      accessToken: accessToken,
    );
  }

  Future<UserModel> updateMe(
    Map<String, dynamic> payload, {
    String? accessToken,
  }) {
    return getObject(
      '/api/v1/users/me',
      UserModel.fromJson,
      accessToken: accessToken,
    );
  }
}
