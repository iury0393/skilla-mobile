import 'package:skilla/model/user.dart';

import 'config/api_service.dart';

class FollowingNetwork {
  final service = APIService();

  Future<List<User>> doRequestGetFollowing() async {
    final response = await service.doRequest(
      RequestConfig('auth/users', HttpMethod.get),
    );

    return Users.fromJson(response).data;
  }
}
