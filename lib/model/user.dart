import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable(explicitToJson: true)
class User {
  String id;
  String fullname;
  String username;
  String email;
  String password;
  String avatar;
  String bio;
  String website;
  int followersCount;
  int followingCount;
  int postCount;

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
      this.website});

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);

  @override
  String toString() {
    return "id: $id, avatar: $avatar, bio: $bio, email: $email, followersCount: $followersCount, followingCount: $followingCount, fullname: $fullname, password: $password, postCount: $postCount, username: $username, website: $website";
  }
}
