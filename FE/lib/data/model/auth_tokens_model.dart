import 'model_utils.dart';

class AuthTokensModel {
  final String accessToken;
  final String refreshToken;
  final bool? isNewUser;

  const AuthTokensModel({
    required this.accessToken,
    required this.refreshToken,
    this.isNewUser,
  });

  factory AuthTokensModel.fromJson(Map<String, dynamic> json) {
    return AuthTokensModel(
      accessToken: readString(json, ['accessToken', 'access_token'])!,
      refreshToken: readString(json, ['refreshToken', 'refresh_token'])!,
      isNewUser: readBool(json, ['isNewUser', 'is_new_user']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'access_token': accessToken,
      'refresh_token': refreshToken,
      'is_new_user': isNewUser,
    };
  }
}
