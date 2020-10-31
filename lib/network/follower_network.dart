import 'package:skilla/model/user.dart';

import 'config/api_service.dart';

class FollowerNetwork {
  final service = APIService();

  Future<List<User>> doRequestgetUsers() async {
    final response = await service.doRequest(
      RequestConfig('auth/users', HttpMethod.get),
    );

    return Users.fromJson(response).data;
  }
}
