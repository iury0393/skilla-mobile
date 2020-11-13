import 'package:skilla/utils/model/user.dart';
import 'package:skilla/utils/network/api_service.dart';

class FollowingNetwork {
  final service = APIService();

  Future<List<User>> doRequestGetFollowing() async {
    final response = await service.doRequest(
      RequestConfig('auth/users', HttpMethod.get),
    );

    return Users.fromJson(response).data;
  }
}
