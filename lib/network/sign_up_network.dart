import 'package:skilla/network/config/api_service.dart';

class SignUpNetwork {
  final service = APIService();

  doRequestRegister(Map<String, dynamic> body) async {
    await service.doRequest(
      RequestConfig('auth/signup', HttpMethod.post, body: body),
    );
  }
}
