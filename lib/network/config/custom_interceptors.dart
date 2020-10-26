import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:skilla/dao/auth_dao.dart';
import 'package:skilla/dao/error_message_dao.dart';
import 'package:skilla/model/auth.dart';
import 'package:skilla/model/error_response.dart';
import 'package:skilla/utils/constants.dart';
import 'package:skilla/utils/user_auth.dart';
import 'package:skilla/utils/utils.dart';

class CustomInterceptors extends InterceptorsWrapper {
  Dio _dio;

  CustomInterceptors(this._dio);

  @override
  Future onRequest(RequestOptions options) async {
    options.headers = await _getDefaultHeaders();
    return super.onRequest(options);
  }

  @override
  Future onResponse(Response response) async {
    return super.onResponse(response);
  }

  @override
  Future onError(DioError err) async {
    Dio dio = Dio();
    if (kDebugMode) {
      dio.interceptors.add(PrettyDioLogger(
          requestHeader: true,
          requestBody: true,
          responseBody: true,
          responseHeader: false,
          error: true,
          compact: true,
          maxWidth: 90));
    }

    if (err.response?.statusCode == 401) {
      _dio.interceptors.requestLock.lock();
      _dio.interceptors.responseLock.lock();
    } else {
      return await _parserError(err);
    }
  }

  Future<FetchDataException> _parserError(DioError err) async {
    if (err.error is SocketException) {
      return FetchDataException(Utils.appLanguage == "pt-BR"
          ? "Verifique sua conexão com a internet."
          : "No Internet connection");
    } else {
      try {
        if (err.response.statusCode == 401) {
          return FetchDataException("401");
        } else {
          var errorResponse = ErrorResponse.fromJson(err?.response?.data);
          if (errorResponse.errors.length > 0) {
            var error = await _getErrorByCode(errorResponse.errors.first);
            if (error != null) {
              return FetchDataException(error);
            }

            return FetchDataException(Utils.appLanguage == "pt-BR"
                ? "Nenhuma mensagem encontrada - code: ${err?.response?.statusCode}"
                : "No error message found - code: ${err?.response?.statusCode}");
          } else {
            return FetchDataException(Utils.appLanguage == "pt-BR"
                ? "Nenhuma mensagem encontrada - code: ${err?.response?.statusCode}"
                : "No error message found - code: ${err?.response?.statusCode}");
          }
        }
      } catch (e) {
        try {
          var data = err?.response?.data['code'];
          var error = await _getErrorByCode(data);
          return FetchDataException(error);
        } catch (e) {
          return FetchDataException(Utils.appLanguage == "pt-BR"
              ? "Nenhuma mensagem encontrada - code: ${err?.response?.statusCode}"
              : "No error message found - code: ${err?.response?.statusCode}");
        }
      }
    }
  }

  Future<Map<String, String>> _getDefaultHeaders() async {
    final deviceId = await Utils.getUUID();
    final appVersion = await Utils.getAppVersion();

    Map<String, String> headers = {
      "Content-type": "application/json",
      "UUID": deviceId,
      "App-version": appVersion,
      "Accept": "application/json",
      "Client-ID": kClientId,
      "Accept-Language": Utils.appLanguage
    };

    if (UserAuth.auth != null) {
      headers['authorization'] = "Bearer ${UserAuth.auth.token}";
    } else {
      var auth = await _getAuthorization();
      if (auth != null) {
        headers['authorization'] = "Bearer ${auth.token}";
      } else {
        return headers;
      }
    }

    return headers;
  }

  Future<Auth> _getAuthorization() async {
    var auth = await AuthDAO().get();
    if (auth.data != null) {
      return auth.data;
    }
    return null;
  }

  Future<String> _getErrorByCode(String code) async {
    var result = await ErrorMessageDAO().getMessageByCode(code);
    if (result.data != null) {
      return result.data.message;
    }
    return code;
  }
}

class AppException extends DioError {
  final _message;
  final _prefix;

  AppException([this._message, this._prefix]);

  String toString() {
    return "$_prefix $_message";
  }
}

class FetchDataException extends AppException {
  FetchDataException([String json]) : super(json, "");
}
