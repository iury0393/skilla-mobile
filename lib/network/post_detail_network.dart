import 'package:skilla/model/post.dart';

import 'config/api_service.dart';

class PostDetailNetwork {
  final service = APIService();

  Future<List<Post>> doRequestgetFeed() async {
    final response = await service.doRequest(
      RequestConfig('users/feed', HttpMethod.get),
    );

    return Posts.fromJson(response).data;
  }

  Future doRequestAddComment(String postId, Map<String, dynamic> body) async {
    await service.doRequest(
      RequestConfig('posts/$postId/comments', HttpMethod.post, body: body),
    );
  }

  Future doRequestDeteleComment(String commentId, String postId) async {
    await service.doRequest(
      RequestConfig('posts/$postId/comments/$commentId', HttpMethod.delete),
    );
  }
}
