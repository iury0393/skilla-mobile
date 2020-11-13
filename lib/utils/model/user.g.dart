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
    id: json['_id'] as String,
    password: json['password'] as String,
    postCount: json['postCount'] as int,
    username: json['username'] as String,
    website: json['website'] as String,
    followers: json['followers'],
    following: json['following'],
    posts: json['posts'],
  );
}

Map<String, dynamic> _$UserToJson(User instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('_id', instance.id);
  writeNotNull('fullname', instance.fullname);
  writeNotNull('username', instance.username);
  writeNotNull('email', instance.email);
  writeNotNull('password', instance.password);
  writeNotNull('avatar', instance.avatar);
  writeNotNull('bio', instance.bio);
  writeNotNull('website', instance.website);
  writeNotNull('followersCount', instance.followersCount);
  writeNotNull('followers', instance.followers);
  writeNotNull('followingCount', instance.followingCount);
  writeNotNull('following', instance.following);
  writeNotNull('postCount', instance.postCount);
  writeNotNull('posts', instance.posts);
  return val;
}

Users _$UsersFromJson(Map<String, dynamic> json) {
  return Users(
    data: (json['data'] as List)
        ?.map(
            (e) => e == null ? null : User.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$UsersToJson(Users instance) => <String, dynamic>{
      'data': instance.data?.map((e) => e?.toJson())?.toList(),
    };
