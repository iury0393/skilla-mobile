import 'package:skilla/model/comment.dart';
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

  Future<Comment> doRequestAddComment(
      String postId, Map<String, dynamic> body) async {
    var response = await service.doRequest(
      RequestConfig('posts/$postId/comments', HttpMethod.post, body: body),
    );

    return Comment.fromJson(response['data']);
  }

  Future doRequestDeteleComment(String commentId, String postId) async {
    await service.doRequest(
      RequestConfig('posts/$postId/comments/$commentId', HttpMethod.delete),
    );
  }
}
