import 'model_utils.dart';

class CommunityPostModel {
  final int id;
  final int userId;
  final String title;
  final String content;
  final String? imageUrl;
  final int likeCount;
  final int commentCount;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;

  const CommunityPostModel({
    required this.id,
    required this.userId,
    required this.title,
    required this.content,
    this.imageUrl,
    required this.likeCount,
    required this.commentCount,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
  });

  factory CommunityPostModel.fromJson(Map<String, dynamic> json) {
    return CommunityPostModel(
      id: readInt(json, ['id'])!,
      userId: readInt(json, ['user_id', 'userId'])!,
      title: readString(json, ['title'])!,
      content: readString(json, ['content'])!,
      imageUrl: readString(json, ['image_url', 'imageUrl']),
      likeCount: readInt(json, ['like_count', 'likeCount'])!,
      commentCount: readInt(json, ['comment_count', 'commentCount'])!,
      createdAt: readDateTime(json, ['created_at', 'createdAt'])!,
      updatedAt: readDateTime(json, ['updated_at', 'updatedAt'])!,
      deletedAt: readDateTime(json, ['deleted_at', 'deletedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'title': title,
      'content': content,
      'image_url': imageUrl,
      'like_count': likeCount,
      'comment_count': commentCount,
      'created_at': writeDateTime(createdAt),
      'updated_at': writeDateTime(updatedAt),
      'deleted_at': writeDateTime(deletedAt),
    };
  }
}
