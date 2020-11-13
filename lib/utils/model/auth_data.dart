import 'package:json_annotation/json_annotation.dart';

part 'auth_data.g.dart';

@JsonSerializable(explicitToJson: true)
class AuthData {
  String email;
  String password;

  AuthData({this.email, this.password});

  Map<String, dynamic> toJson() => _$AuthDataToJson(this);

  @override
  String toString() {
    return "email: $email, password: $password";
  }
}
