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
}
