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
    id: json['_id'] as String,
    isCommentMine: json['isCommentMine'] as bool,
  );
}

Map<String, dynamic> _$CommentToJson(Comment instance) => <String, dynamic>{
      '_id': instance.id,
      'user': instance.user?.toJson(),
      'text': instance.text,
      'isCommentMine': instance.isCommentMine,
    };

Comments _$CommentsFromJson(Map<String, dynamic> json) {
  return Comments(
    comments: (json['comments'] as List)
        ?.map((e) =>
            e == null ? null : Comment.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$CommentsToJson(Comments instance) => <String, dynamic>{
      'comments': instance.comments?.map((e) => e?.toJson())?.toList(),
    };
