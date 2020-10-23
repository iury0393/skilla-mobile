import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:skilla/network/config/custom_interceptors.dart';
import 'package:skilla/utils/constants.dart';

enum HttpMethod { get, post, patch, delete }

class RequestConfig {
  final String path;
  final HttpMethod method;
  final dynamic body;
  final dynamic parameters;

  RequestConfig(
    this.path,
    this.method, {
    this.body,
    this.parameters,
  });
}

class APIService {
  Dio dio = Dio();

  final Duration _timeout = Duration(seconds: 60);

  APIService() {
    dio.interceptors.add(CustomInterceptors(dio));
  }

  Future<Map<String, dynamic>> doRequest(RequestConfig config) async {
    String url = kBaseURL;
    url += config.path;

    var responseJson;

    switch (config.method) {
      case HttpMethod.get:
        final response = await dio.get(url).timeout(_timeout);
        responseJson = _handlerResponse(response);
        break;
      case HttpMethod.post:
        print(url);
        var body;
        if (config.body is FormData) {
          body = config.body;
        } else {
          body = jsonEncode(config.body);
        }
        final response = await dio.post(url, data: body).timeout(_timeout);
        responseJson = _handlerResponse(response);
        break;
      case HttpMethod.patch:
        var body;
        if (config.body is FormData) {
          body = config.body;
        } else {
          body = jsonEncode(config.body);
        }
        final response = await dio.patch(url, data: body).timeout(_timeout);
        responseJson = _handlerResponse(response);
        break;
      case HttpMethod.delete:
        final response = await dio.delete(url).timeout(_timeout);
        responseJson = _handlerResponse(response);
        break;
    }

    return responseJson;
  }

  Map<String, dynamic> _handlerResponse(Response response) {
    if (response.statusCode >= 200 && response.statusCode <= 299) {
      try {
        var result = json.decode(response.data.toString());
        return result;
      } catch (e) {
        try {
          return response.data;
        } catch (e) {
          return Map<String, dynamic>();
        }
      }
    } else {
      return response.data;
    }
  }
}
