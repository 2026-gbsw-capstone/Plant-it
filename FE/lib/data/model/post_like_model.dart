import 'model_utils.dart';

class PostLikeModel {
  final int id;
  final int postId;
  final int userId;
  final DateTime createdAt;

  const PostLikeModel({
    required this.id,
    required this.postId,
    required this.userId,
    required this.createdAt,
  });

  factory PostLikeModel.fromJson(Map<String, dynamic> json) {
    return PostLikeModel(
      id: readInt(json, ['id'])!,
      postId: readInt(json, ['post_id', 'postId'])!,
      userId: readInt(json, ['user_id', 'userId'])!,
      createdAt: readDateTime(json, ['created_at', 'createdAt'])!,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'post_id': postId,
      'user_id': userId,
      'created_at': writeDateTime(createdAt),
    };
  }
}
