import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable(explicitToJson: true, includeIfNull: false)
class User {
  @JsonKey(name: "_id")
  String id;
  String fullname;
  String username;
  String email;
  String password;
  String avatar;
  String bio;
  String website;
  int followersCount;
  var followers;
  int followingCount;
  var following;
  int postCount;
  var posts;

  User(
      {this.avatar,
      this.bio,
      this.email,
      this.followersCount,
      this.followingCount,
      this.fullname,
      this.id,
      this.password,
      this.postCount,
      this.username,
      this.website,
      this.followers,
      this.following,
      this.posts});

  generateDataFromUser(User user) {
    return User(
        id: user.id,
        avatar: user.avatar,
        fullname: user.fullname,
        username: user.username,
        website: user.website,
        bio: user.bio,
        email: user.email,
        followersCount: user.followersCount,
        followingCount: user.followingCount,
        postCount: user.postCount,
        password: user.password,
        posts: user.posts,
        followers: user.followers,
        following: user.following);
  }

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);

  @override
  String toString() {
    return "id: $id, avatar: $avatar, bio: $bio, email: $email, followersCount: $followersCount, followingCount: $followingCount, fullname: $fullname, password: $password, postCount: $postCount, username: $username, website: $website, followers: $followers, following: $following, posts: $posts";
  }
}

@JsonSerializable(explicitToJson: true)
class Users {
  List<User> data;

  Users({this.data});

  factory Users.fromJson(Map<String, dynamic> json) => _$UsersFromJson(json);

  Map<String, dynamic> toJson() => _$UsersToJson(this);

  @override
  String toString() {
    return "data: $data";
  }
}
