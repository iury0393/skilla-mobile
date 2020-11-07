import 'package:skilla/model/post.dart';

import 'config/api_service.dart';

class PostDetailProfileNetwork {
  final service = APIService();

  Future<Post> doRequestGetPost(String postId) async {
    final response = await service.doRequest(
      RequestConfig('posts/$postId', HttpMethod.get),
    );

    return Post.fromJson(response['data']);
  }
}
