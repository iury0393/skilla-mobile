// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'error_message.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ErrorMessage _$ErrorMessageFromJson(Map<String, dynamic> json) {
  return ErrorMessage(
    lastUpdate: json['lastUpdate'] as String,
    code: json['code'] as String,
    message: json['message'] as String,
    lang: json['lang'] as String,
  );
}

Map<String, dynamic> _$ErrorMessageToJson(ErrorMessage instance) =>
    <String, dynamic>{
      'code': instance.code,
      'message': instance.message,
      'lang': instance.lang,
      'lastUpdate': instance.lastUpdate,
    };
