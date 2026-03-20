import 'model_utils.dart';

enum LoginType { email, google }

extension LoginTypeJson on LoginType {
  static LoginType fromJson(String value) {
    switch (value) {
      case 'EMAIL':
        return LoginType.email;
      case 'GOOGLE':
        return LoginType.google;
      default:
        throw ArgumentError('Unknown loginType: $value');
    }
  }

  String toJson() {
    switch (this) {
      case LoginType.email:
        return 'EMAIL';
      case LoginType.google:
        return 'GOOGLE';
    }
  }
}

class UserModel {
  final int id;
  final String email;
  final String? password;
  final String nickname;
  final String? profileImageUrl;
  final LoginType loginType;
  final DateTime createdAt;
  final DateTime updatedAt;

  const UserModel({
    required this.id,
    required this.email,
    this.password,
    required this.nickname,
    this.profileImageUrl,
    required this.loginType,
    required this.createdAt,
    required this.updatedAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: readInt(json, ['id'])!,
      email: readString(json, ['email'])!,
      password: readString(json, ['password']),
      nickname: readString(json, ['nickname'])!,
      profileImageUrl: readString(json, ['profile_image_url', 'profileImageUrl']),
      loginType: LoginTypeJson.fromJson(
        readString(json, ['login_type', 'loginType'])!,
      ),
      createdAt: readDateTime(json, ['created_at', 'createdAt'])!,
      updatedAt: readDateTime(json, ['updated_at', 'updatedAt'])!,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'password': password,
      'nickname': nickname,
      'profile_image_url': profileImageUrl,
      'login_type': loginType.toJson(),
      'created_at': writeDateTime(createdAt),
      'updated_at': writeDateTime(updatedAt),
    };
  }
}
