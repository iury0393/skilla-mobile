import 'package:skilla/model/user.dart';
import 'package:skilla/network/config/api_service.dart';

class UserService {
  final service = APIService();

  Future<User> doRequestGetUser() async {
    final response = await service.doRequest(
      RequestConfig('auth/me', HttpMethod.get),
    );

    return User.fromJson(response['data']);
  }
}
