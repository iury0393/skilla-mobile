import 'package:skilla/model/post.dart';
import 'package:skilla/model/user.dart';

import 'config/api_service.dart';

class LikesNetwork {
  final service = APIService();

  Future<List<User>> doRequestgetUsers() async {
    final response = await service.doRequest(
      RequestConfig('auth/users', HttpMethod.get),
    );

    return Users.fromJson(response).data;
  }

  Future<List<Post>> doRequestgetFeed() async {
    final response = await service.doRequest(
      RequestConfig('users/feed', HttpMethod.get),
    );

    return Posts.fromJson(response).data;
  }

  doRequestToggleLike(String postId) async {
    await service.doRequest(
      RequestConfig('posts/$postId/togglelike', HttpMethod.get),
    );
  }
}
