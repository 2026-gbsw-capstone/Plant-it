import '../model/community_comment_model.dart';
import 'base_data_service.dart';

class CommunityCommentDataService extends BaseDataService {
  CommunityCommentDataService({super.client});

  Future<dynamic> createComment(
    int postId,
    String content, {
    String? accessToken,
  }) {
    return postData(
      '/api/v1/community/posts/$postId/comments',
      accessToken: accessToken,
      body: {
        'content': content,
      },
    );
  }

  Future<List<CommunityCommentModel>> fetchComments(
    int postId, {
    String? accessToken,
  }) {
    return getList(
      '/api/v1/community/posts/$postId/comments',
      CommunityCommentModel.fromJson,
      accessToken: accessToken,
    );
  }

  Future<void> deleteComment(
    int commentId, {
    String? accessToken,
  }) async {
    await deleteData(
      '/api/v1/community/comments/$commentId',
      accessToken: accessToken,
    );
  }
}
