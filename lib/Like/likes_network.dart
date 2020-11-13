import 'package:skilla/utils/model/post.dart';
import 'package:skilla/utils/model/user.dart';
import 'package:skilla/utils/network/api_service.dart';

class LikesNetwork {
  final service = APIService();

  Future<List<User>> doRequestGetUsers() async {
    final response = await service.doRequest(
      RequestConfig('auth/users', HttpMethod.get),
    );

    return Users.fromJson(response).data;
  }

  Future<List<Post>> doRequestGetFeed() async {
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
