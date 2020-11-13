import 'package:json_annotation/json_annotation.dart';

part 'post_detail.g.dart';

@JsonSerializable(explicitToJson: true)
class PostDetail {
  String user;
  String caption;
  @JsonKey(name: "_id")
  String id;
  var files;
  var likes;
  var tags;
  var comments;
  int likesCount;
  int commentsCount;
  DateTime createdAt;

  PostDetail(
      {this.caption,
      this.commentsCount,
      this.createdAt,
      this.likesCount,
      this.user,
      this.id,
      this.files,
      this.comments,
      this.likes,
      this.tags});

  factory PostDetail.fromJson(Map<String, dynamic> json) =>
      _$PostDetailFromJson(json);

  Map<String, dynamic> toJson() => _$PostDetailToJson(this);

  @override
  String toString() {
    return "id: $id, user: $user, caption: $caption, likesCount: $likesCount, commentsCount: $commentsCount, createdAt: $createdAt, files: $files, likes: $likes, comments: $comments, tags: $tags";
  }
}

@JsonSerializable(explicitToJson: true)
class PostDetails {
  List<PostDetail> data;

  PostDetails({this.data});

  factory PostDetails.fromJson(Map<String, dynamic> json) =>
      _$PostDetailsFromJson(json);

  Map<String, dynamic> toJson() => _$PostDetailsToJson(this);

  @override
  String toString() {
    return "data: $data";
  }
}
