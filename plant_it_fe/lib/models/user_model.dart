class UserModel {
  const UserModel({
    required this.id,
    required this.email,
    required this.nickname,
    this.profileImageUrl,
  });

  final int id;
  final String email;
  final String nickname;
  final String? profileImageUrl;

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: (json['id'] as num?)?.toInt() ?? 0,
      email: json['email'] as String? ?? '',
      nickname: json['nickname'] as String? ?? '',
      profileImageUrl: json['profileImageUrl'] as String?,
    );
  }
}
