import 'package:json_annotation/json_annotation.dart';
import 'package:skilla/model/user_comment.dart';

part 'comment.g.dart';

@JsonSerializable(explicitToJson: true)
class Comment {
  @JsonKey(name: "_id")
  String id;
  UserComment user;
  String text;
  bool isCommentMine;

  Comment({this.text, this.user, this.id, this.isCommentMine});

  factory Comment.fromJson(Map<String, dynamic> json) =>
      _$CommentFromJson(json);

  Map<String, dynamic> toJson() => _$CommentToJson(this);

  @override
  String toString() {
    return "id: $id, user: $user, isCommentMine: $isCommentMine, text: $text";
  }
}

@JsonSerializable(explicitToJson: true)
class Comments {
  List<Comment> comments;

  Comments({this.comments});

  factory Comments.fromJson(Map<String, dynamic> json) =>
      _$CommentsFromJson(json);

  Map<String, dynamic> toJson() => _$CommentsToJson(this);

  @override
  String toString() {
    return "comments: $comments";
  }
}
