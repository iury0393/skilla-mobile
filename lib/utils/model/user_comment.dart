import 'package:json_annotation/json_annotation.dart';

part 'user_comment.g.dart';

@JsonSerializable(explicitToJson: true, includeIfNull: false)
class UserComment {
  @JsonKey(name: "_id")
  String id;
  String fullname;
  String username;
  String avatar;

  UserComment({
    this.avatar,
    this.fullname,
    this.id,
    this.username,
  });

  factory UserComment.fromJson(Map<String, dynamic> json) =>
      _$UserCommentFromJson(json);

  Map<String, dynamic> toJson() => _$UserCommentToJson(this);

  @override
  String toString() {
    return "id: $id, avatar: $avatar, fullname: $fullname, username: $username";
  }
}
