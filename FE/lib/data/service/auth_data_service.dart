import '../model/auth_tokens_model.dart';
import '../model/id_response_model.dart';
import '../model/user_model.dart';
import 'base_data_service.dart';

class AuthDataService extends BaseDataService {
  AuthDataService({super.client});

  Future<IdResponseModel> signUp({
    required String email,
    required String password,
    required String nickname,
  }) {
    return postObject(
      '/api/v1/auth/signup',
      (json) => IdResponseModel.fromJson(json, keys: const ['userId', 'id']),
      body: {
        'email': email,
        'password': password,
        'nickname': nickname,
      },
    );
  }

  Future<AuthTokensModel> login({
    required String email,
    required String password,
  }) {
    return postObject(
      '/api/v1/auth/login',
      AuthTokensModel.fromJson,
      body: {
        'email': email,
        'password': password,
      },
    );
  }

  Future<AuthTokensModel> googleLogin({
    required String idToken,
  }) {
    return postObject(
      '/api/v1/auth/google',
      AuthTokensModel.fromJson,
      body: {
        'idToken': idToken,
      },
    );
  }

  Future<UserModel> fetchMe({required String accessToken}) {
    return getObject(
      '/api/v1/users/me',
      UserModel.fromJson,
      accessToken: accessToken,
    );
  }
}
