// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post_detail.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PostDetail _$PostDetailFromJson(Map<String, dynamic> json) {
  return PostDetail(
    caption: json['caption'] as String,
    commentsCount: json['commentsCount'] as int,
    createdAt: json['createdAt'] == null
        ? null
        : DateTime.parse(json['createdAt'] as String),
    likesCount: json['likesCount'] as int,
    user: json['user'] as String,
    id: json['_id'] as String,
    files: json['files'],
    comments: json['comments'],
    likes: json['likes'],
    isLiked: json['isLiked'] as bool,
    isMine: json['isMine'] as bool,
    tags: json['tags'],
  );
}

Map<String, dynamic> _$PostDetailToJson(PostDetail instance) =>
    <String, dynamic>{
      'user': instance.user,
      'caption': instance.caption,
      '_id': instance.id,
      'files': instance.files,
      'likes': instance.likes,
      'tags': instance.tags,
      'comments': instance.comments,
      'likesCount': instance.likesCount,
      'commentsCount': instance.commentsCount,
      'createdAt': instance.createdAt?.toIso8601String(),
      'isLiked': instance.isLiked,
      'isMine': instance.isMine,
    };

PostDetails _$PostDetailsFromJson(Map<String, dynamic> json) {
  return PostDetails(
    data: (json['data'] as List)
        ?.map((e) =>
            e == null ? null : PostDetail.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$PostDetailsToJson(PostDetails instance) =>
    <String, dynamic>{
      'data': instance.data?.map((e) => e?.toJson())?.toList(),
    };
