import 'package:skilla/utils/model/user.dart';
import 'package:skilla/utils/network/api_service.dart';

class UserNetwork {
  final service = APIService();

  Future<User> doRequestGetUser() async {
    final response = await service.doRequest(
      RequestConfig('auth/me', HttpMethod.get),
    );

    return User.fromJson(response['data']);
  }
}
