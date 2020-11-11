import 'package:skilla/model/comment.dart';

import 'config/api_service.dart';

class PostDetailNetwork {
  final service = APIService();

  Future<Comment> doRequestAddComment(
      String postId, Map<String, dynamic> body) async {
    var response = await service.doRequest(
      RequestConfig('posts/$postId/comments', HttpMethod.post, body: body),
    );

    return Comment.fromJson(response['data']);
  }

  Future doRequestDeleteComment(String commentId, String postId) async {
    await service.doRequest(
      RequestConfig('posts/$postId/comments/$commentId', HttpMethod.delete),
    );
  }
}
