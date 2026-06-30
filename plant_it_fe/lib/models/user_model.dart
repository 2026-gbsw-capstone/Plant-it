class UserModel {
  const UserModel({
    required this.id,
    required this.email,
    required this.nickname,
    this.profileImageUrl,
    this.createdAt,
  });

  final int id;
  final String email;
  final String nickname;
  final String? profileImageUrl;
  final DateTime? createdAt;

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: (json['id'] as num?)?.toInt() ?? 0,
      email: json['email'] as String? ?? '',
      nickname: json['nickname'] as String? ?? '',
      profileImageUrl: json['profileImageUrl'] as String?,
      createdAt: json['createdAt'] is String
          ? DateTime.tryParse(json['createdAt'] as String)
          : null,
    );
  }
}
