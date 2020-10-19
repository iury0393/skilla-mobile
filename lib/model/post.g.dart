// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Post _$PostFromJson(Map<String, dynamic> json) {
  return Post(
    caption: json['caption'] as String,
    commentCount: json['commentCount'] as int,
    createdAt: json['createdAt'] as String,
    file: json['file'] as String,
    likesCount: json['likesCount'] as int,
    user: json['user'] == null
        ? null
        : User.fromJson(json['user'] as Map<String, dynamic>),
    id: json['id'] as String,
  );
}

Map<String, dynamic> _$PostToJson(Post instance) => <String, dynamic>{
      'user': instance.user?.toJson(),
      'id': instance.id,
      'caption': instance.caption,
      'file': instance.file,
      'likesCount': instance.likesCount,
      'commentCount': instance.commentCount,
      'createdAt': instance.createdAt,
    };
