import 'package:skilla/model/post.dart';
import 'package:skilla/model/post_detail.dart';
import 'package:skilla/model/user.dart';

import 'config/api_service.dart';

class ProfileNetwork {
  final service = APIService();

  Future<List<PostDetail>> doRequestGetPosts() async {
    var response = await service.doRequest(
      RequestConfig('posts/', HttpMethod.get),
    );

    return PostDetails.fromJson(response).data;
  }

  Future<Post> doRequestGetPost(String postId) async {
    final response = await service.doRequest(
      RequestConfig('posts/$postId', HttpMethod.get),
    );

    return Post.fromJson(response['data']);
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
