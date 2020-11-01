// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_comment.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserComment _$UserCommentFromJson(Map<String, dynamic> json) {
  return UserComment(
    avatar: json['avatar'] as String,
    fullname: json['fullname'] as String,
    id: json['id'],
    username: json['username'] as String,
  );
}

Map<String, dynamic> _$UserCommentToJson(UserComment instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('id', instance.id);
  writeNotNull('fullname', instance.fullname);
  writeNotNull('username', instance.username);
  writeNotNull('avatar', instance.avatar);
  return val;
}
