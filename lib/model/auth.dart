import 'package:json_annotation/json_annotation.dart';

part 'auth.g.dart';

@JsonSerializable(explicitToJson: true)
class Auth {
  bool success;
  String token;

  Auth({this.success, this.token});

  factory Auth.fromJson(Map<String, dynamic> json) => _$AuthFromJson(json);

  Map<String, dynamic> toJson() => _$AuthToJson(this);

  @override
  String toString() {
    return "success: $success, token: $token";
  }
}
