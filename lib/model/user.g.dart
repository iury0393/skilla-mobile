// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) {
  return User(
    avatar: json['avatar'] as String,
    bio: json['bio'] as String,
    email: json['email'] as String,
    followersCount: json['followersCount'] as int,
    followingCount: json['followingCount'] as int,
    fullname: json['fullname'] as String,
    id: json['id'] as String,
    password: json['password'] as String,
    postCount: json['postCount'] as int,
    username: json['username'] as String,
    website: json['website'] as String,
  );
}

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'id': instance.id,
      'fullname': instance.fullname,
      'username': instance.username,
      'email': instance.email,
      'password': instance.password,
      'avatar': instance.avatar,
      'bio': instance.bio,
      'website': instance.website,
      'followersCount': instance.followersCount,
      'followingCount': instance.followingCount,
      'postCount': instance.postCount,
    };
