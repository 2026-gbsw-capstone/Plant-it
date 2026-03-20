import '../model/community_post_model.dart';
import 'base_data_service.dart';

class CommunityPostDataService extends BaseDataService {
  CommunityPostDataService({super.client});

  Future<dynamic> createPost(
    Map<String, dynamic> payload, {
    String? accessToken,
  }) {
    return postData(
      '/api/v1/community/posts',
      accessToken: accessToken,
      body: payload,
    );
  }

  Future<List<CommunityPostModel>> fetchPosts({
    String? accessToken,
    int? page,
    int? size,
    String? keyword,
    String? sort,
  }) {
    return getList(
      '/api/v1/community/posts',
      CommunityPostModel.fromJson,
      accessToken: accessToken,
      queryParameters: {
        'page': page,
        'size': size,
        'keyword': keyword,
        'sort': sort,
      },
    );
  }

  Future<CommunityPostModel> fetchPost(
    int postId, {
    String? accessToken,
  }) {
    return getObject(
      '/api/v1/community/posts/$postId',
      CommunityPostModel.fromJson,
      accessToken: accessToken,
    );
  }

  Future<dynamic> updatePost(
    int postId,
    Map<String, dynamic> payload, {
    String? accessToken,
  }) {
    return patchData(
      '/api/v1/community/posts/$postId',
      accessToken: accessToken,
      body: payload,
    );
  }

  Future<void> deletePost(
    int postId, {
    String? accessToken,
  }) async {
    await deleteData(
      '/api/v1/community/posts/$postId',
      accessToken: accessToken,
    );
  }

  Future<void> likePost(
    int postId, {
    String? accessToken,
  }) async {
    await postData(
      '/api/v1/community/posts/$postId/like',
      accessToken: accessToken,
    );
  }

  Future<void> unlikePost(
    int postId, {
    String? accessToken,
  }) async {
    await deleteData(
      '/api/v1/community/posts/$postId/like',
      accessToken: accessToken,
    );
  }
}
