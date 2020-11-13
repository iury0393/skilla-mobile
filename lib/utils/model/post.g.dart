// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Post _$PostFromJson(Map<String, dynamic> json) {
  return Post(
    caption: json['caption'] as String,
    commentsCount: json['commentsCount'] as int,
    createdAt: json['createdAt'] == null
        ? null
        : DateTime.parse(json['createdAt'] as String),
    likesCount: json['likesCount'] as int,
    user: json['user'] == null
        ? null
        : User.fromJson(json['user'] as Map<String, dynamic>),
    id: json['_id'] as String,
    files: json['files'],
    comments: (json['comments'] as List)
        ?.map((e) =>
            e == null ? null : Comment.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    likes: json['likes'],
    isLiked: json['isLiked'] as bool,
    isMine: json['isMine'] as bool,
    tags: json['tags'],
  );
}

Map<String, dynamic> _$PostToJson(Post instance) => <String, dynamic>{
      'user': instance.user?.toJson(),
      'caption': instance.caption,
      '_id': instance.id,
      'files': instance.files,
      'likes': instance.likes,
      'tags': instance.tags,
      'comments': instance.comments?.map((e) => e?.toJson())?.toList(),
      'likesCount': instance.likesCount,
      'commentsCount': instance.commentsCount,
      'createdAt': instance.createdAt?.toIso8601String(),
      'isLiked': instance.isLiked,
      'isMine': instance.isMine,
    };

Posts _$PostsFromJson(Map<String, dynamic> json) {
  return Posts(
    data: (json['data'] as List)
        ?.map(
            (e) => e == null ? null : Post.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$PostsToJson(Posts instance) => <String, dynamic>{
      'data': instance.data?.map((e) => e?.toJson())?.toList(),
    };
