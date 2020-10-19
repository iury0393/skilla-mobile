// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'comment.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Comment _$CommentFromJson(Map<String, dynamic> json) {
  return Comment(
    post: json['post'] == null
        ? null
        : Post.fromJson(json['post'] as Map<String, dynamic>),
    text: json['text'] as String,
    createdAt: json['createdAt'] as String,
    user: json['user'] == null
        ? null
        : User.fromJson(json['user'] as Map<String, dynamic>),
    id: json['id'] as String,
  );
}

Map<String, dynamic> _$CommentToJson(Comment instance) => <String, dynamic>{
      'id': instance.id,
      'user': instance.user?.toJson(),
      'post': instance.post?.toJson(),
      'text': instance.text,
      'createdAt': instance.createdAt,
    };
