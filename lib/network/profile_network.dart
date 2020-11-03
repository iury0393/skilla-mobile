import 'package:skilla/model/post.dart';
import 'package:skilla/model/user.dart';

import 'config/api_service.dart';

class ProfileNetwork {
  final service = APIService();

  Future<List<Post>> doRequestGetPosts() async {
    var response = await service.doRequest(
      RequestConfig('users/feed', HttpMethod.get),
    );

    return Posts.fromJson(response).data;
  }

  Future doRequestFollow(String id) async {
    await service.doRequest(
      RequestConfig('users/$id/follow', HttpMethod.get),
    );
  }

  Future doRequestUnfollow(String id) async {
    await service.doRequest(
      RequestConfig('users/$id/unfollow', HttpMethod.get),
    );
  }

  Future<List<User>> doRequestgetUsers() async {
    final response = await service.doRequest(
      RequestConfig('auth/users', HttpMethod.get),
    );

    return Users.fromJson(response).data;
  }
}
