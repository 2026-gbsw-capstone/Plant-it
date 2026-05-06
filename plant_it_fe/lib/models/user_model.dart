enum LoginType {
  email('EMAIL'),
  google('GOOGLE');

  final String value;

  const LoginType(this.value);

  static LoginType fromJson(String? value) {
    return LoginType.values.firstWhere(
      (type) => type.value == value,
      orElse: () => LoginType.email,
    );
  }
}

class UserModel {
  final int id;
  final String email;
  final String nickname;
  final String? profileImageUrl;
  final LoginType? loginType;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const UserModel({
    required this.id,
    required this.email,
    required this.nickname,
    this.profileImageUrl,
    this.loginType,
    this.createdAt,
    this.updatedAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as int,
      email: json['email'] as String,
      nickname: json['nickname'] as String,
      profileImageUrl: json['profileImageUrl'] as String?,
      loginType: json['loginType'] == null
          ? null
          : LoginType.fromJson(json['loginType'] as String?),
      createdAt: _dateTimeOrNull(json['createdAt']),
      updatedAt: _dateTimeOrNull(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'nickname': nickname,
      'profileImageUrl': profileImageUrl,
      'loginType': loginType?.value,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }
}

DateTime? _dateTimeOrNull(Object? value) {
  if (value == null) return null;
  return DateTime.tryParse(value as String);
}
