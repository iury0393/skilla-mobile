import 'package:json_annotation/json_annotation.dart';
import 'package:skilla/model/user_comment.dart';

part 'comment.g.dart';

@JsonSerializable(explicitToJson: true)
class Comment {
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
