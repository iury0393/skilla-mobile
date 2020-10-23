// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Auth _$AuthFromJson(Map<String, dynamic> json) {
  return Auth(
    success: json['success'] as bool,
    token: json['token'] as String,
  );
}

Map<String, dynamic> _$AuthToJson(Auth instance) => <String, dynamic>{
      'success': instance.success,
      'token': instance.token,
    };
