// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Auth _$AuthFromJson(Map<String, dynamic> json) {
  return Auth(
    id: json['id'] as String,
    refreshToken: json['refresh_token'] as String,
    accessToken: json['access_token'] as String,
    accessTokenTTL: json['access_token_ttl'] as int,
    whenRefresh: json['whenRefresh'] as int,
  );
}

Map<String, dynamic> _$AuthToJson(Auth instance) => <String, dynamic>{
      'id': instance.id,
      'access_token': instance.accessToken,
      'refresh_token': instance.refreshToken,
      'access_token_ttl': instance.accessTokenTTL,
      'whenRefresh': instance.whenRefresh,
    };
