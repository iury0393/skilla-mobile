import 'package:skilla/model/user.dart';

import 'config/api_service.dart';

class SearchNetwork {
  final service = APIService();

  Future<List<User>> doRequestGetUsers() async {
    final response = await service.doRequest(
      RequestConfig('auth/users', HttpMethod.get),
    );

    return Users.fromJson(response).data;
  }

  Future<User> doRequestGetUser(String username) async {
    final response = await service.doRequest(
      RequestConfig('users/$username', HttpMethod.get),
    );

    return User.fromJson(response);
  }
}
