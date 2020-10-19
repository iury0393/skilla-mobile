// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'base_error.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BaseError _$BaseErrorFromJson(Map<String, dynamic> json) {
  return BaseError(
    lastUpdate: json['lastUpdate'] as String,
    messages: (json['messages'] as List)
        ?.map((e) =>
            e == null ? null : ErrorMessage.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$BaseErrorToJson(BaseError instance) => <String, dynamic>{
      'lastUpdate': instance.lastUpdate,
      'messages': instance.messages?.map((e) => e?.toJson())?.toList(),
    };
