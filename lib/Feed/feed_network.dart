import 'package:skilla/utils/model/post.dart';
import 'package:skilla/utils/model/user.dart';
import 'package:skilla/utils/network/api_service.dart';

class FeedNetwork {
  final service = APIService();

  Future<List<Post>> doRequestGetFeed() async {
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

  Future doRequestDeletePost(String postId) async {
    await service.doRequest(
      RequestConfig('posts/$postId', HttpMethod.delete),
    );
  }
}
