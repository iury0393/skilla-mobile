import 'config/api_service.dart';

class PostNetwork {
  final service = APIService();

  doRequestAddPost(Map<String, dynamic> body) async {
    await service.doRequest(
      RequestConfig('posts/', HttpMethod.post, body: body),
    );
  }
}
