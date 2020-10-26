import 'package:skilla/model/auth.dart';
import 'package:skilla/network/config/api_service.dart';

import 'config/api_service.dart';

class SignInNetwork {
  final service = APIService();

  Future<Auth> doRequestLogin(Map<String, dynamic> body) async {
    final response = await service.doRequest(
      RequestConfig('auth/login', HttpMethod.post, body: body),
    );

    return Auth.fromJson(response);
  }
}
