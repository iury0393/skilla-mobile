import 'package:json_annotation/json_annotation.dart';

part 'refresh_token.g.dart';

@JsonSerializable(explicitToJson: true)
class RefreshToken {

  @JsonKey(name: "refresh_token")
  String refreshToken;

  RefreshToken(this.refreshToken);

  Map<String, dynamic> toJson() => _$RefreshTokenToJson(this);

  @override
  String toString() {
    return "refreshToken: $refreshToken";
  }
}
