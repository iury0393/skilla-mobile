import 'package:json_annotation/json_annotation.dart';
import 'package:skilla/model/comment.dart';
import 'package:skilla/model/user.dart';

part 'post.g.dart';

@JsonSerializable(explicitToJson: true)
class Post {
  User user;
  String caption;
  String id;
  var files;
  var likes;
  var comments;
  int likesCount;
  int commentCount;
  DateTime createdAt;

  Post(
      {this.caption,
      this.commentCount,
      this.createdAt,
      this.likesCount,
      this.user,
      this.id,
      this.files,
      this.comments,
      this.likes});

  factory Post.fromJson(Map<String, dynamic> json) => _$PostFromJson(json);

  Map<String, dynamic> toJson() => _$PostToJson(this);

  @override
  String toString() {
    return "id: $id, user: $user, caption: $caption, likesCount: $likesCount, commentCount: $commentCount, createdAt: $createdAt, files: $files, likes: $likes, comments: $comments";
  }
}

@JsonSerializable(explicitToJson: true)
class Posts {
  List<Post> data;

  Posts({this.data});

  factory Posts.fromJson(Map<String, dynamic> json) => _$PostsFromJson(json);

  Map<String, dynamic> toJson() => _$PostsToJson(this);

  @override
  String toString() {
    return "data: $data";
  }
}
