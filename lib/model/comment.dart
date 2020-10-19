import 'package:json_annotation/json_annotation.dart';
import 'package:skilla/model/post.dart';
import 'package:skilla/model/user.dart';

part 'comment.g.dart';

@JsonSerializable(explicitToJson: true)
class Comment {
  String id;
  User user;
  Post post;
  String text;
  String createdAt;

  Comment({this.post, this.text, this.createdAt, this.user, this.id});

  factory Comment.fromJson(Map<String, dynamic> json) =>
      _$CommentFromJson(json);

  Map<String, dynamic> toJson() => _$CommentToJson(this);

  @override
  String toString() {
    return "id: $id, user: $user, post: $post, text: $text, createdAt: $createdAt";
  }
}
