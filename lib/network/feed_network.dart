import 'package:skilla/model/post.dart';
import 'package:skilla/model/user.dart';

import 'config/api_service.dart';

class FeedNetwork {
  final service = APIService();

  Future<List<Post>> doRequestgetFeed() async {
    final response = await service.doRequest(
      RequestConfig('users/feed', HttpMethod.get),
    );

    return Posts.fromJson(response).data;
  }

  Future<User> doRequestGetUser(String username) async {
    final response = await service.doRequest(
      RequestConfig('users/$username', HttpMethod.get),
    );

    return User.fromJson(response['data']);
  }

  Future doRequestDetelePost(String postId) async {
    await service.doRequest(
      RequestConfig('posts/$postId', HttpMethod.delete),
    );
  }
}
