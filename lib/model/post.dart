import 'package:json_annotation/json_annotation.dart';
import 'package:skilla/model/user.dart';

part 'post.g.dart';

@JsonSerializable(explicitToJson: true)
class Post {
  User user;
  String id;
  String caption;
  String file;
  int likesCount;
  int commentCount;
  String createdAt;

  Post(
      {this.caption,
      this.commentCount,
      this.createdAt,
      this.file,
      this.likesCount,
      this.user,
      this.id});

  factory Post.fromJson(Map<String, dynamic> json) => _$PostFromJson(json);

  Map<String, dynamic> toJson() => _$PostToJson(this);

  @override
  String toString() {
    return "id: $id, user: $user, caption: $caption, file: $file, likesCount: $likesCount, commentCount: $commentCount, createdAt: $createdAt";
  }
}
