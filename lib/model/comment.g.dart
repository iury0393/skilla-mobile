// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'comment.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Comment _$CommentFromJson(Map<String, dynamic> json) {
  return Comment(
    text: json['text'] as String,
    user: json['user'] == null
        ? null
        : UserComment.fromJson(json['user'] as Map<String, dynamic>),
    id: json['id'] as String,
    isCommentMine: json['isCommentMine'] as bool,
  );
}

Map<String, dynamic> _$CommentToJson(Comment instance) => <String, dynamic>{
      'id': instance.id,
      'user': instance.user?.toJson(),
      'text': instance.text,
      'isCommentMine': instance.isCommentMine,
    };
