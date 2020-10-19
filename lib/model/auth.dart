import 'package:json_annotation/json_annotation.dart';

part 'auth.g.dart';

@JsonSerializable(explicitToJson: true)
class Auth {

  String id;
  @JsonKey(name: "access_token")
  String accessToken;
  @JsonKey(name: "refresh_token")
  String refreshToken;
  @JsonKey(name: "access_token_ttl")
  int accessTokenTTL;
  int whenRefresh;

  Auth({this.id, this.refreshToken, this.accessToken, this.accessTokenTTL, this.whenRefresh});

  factory Auth.fromJson(Map<String, dynamic> json) => _$AuthFromJson(json);

  Map<String, dynamic> toJson() => _$AuthToJson(this);

  @override
  String toString() {
    return "id: $id, accessToken: $accessToken, accessTokenTTL: $accessTokenTTL, refreshToken: $refreshToken, whenRefresh: $whenRefresh";
  }
}
