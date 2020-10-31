import 'package:skilla/model/user.dart';
import 'package:skilla/network/config/api_service.dart';

import 'config/api_service.dart';

class EditNetwork {
  final service = APIService();

  Future<User> doRequestEdit(Map<String, dynamic> body) async {
    final response = await service.doRequest(
      RequestConfig('users/', HttpMethod.put, body: body),
    );

    return User.fromJson(response['data']);
  }
}
