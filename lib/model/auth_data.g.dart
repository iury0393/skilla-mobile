// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

// ignore: unused_element
AuthData _$AuthDataFromJson(Map<String, dynamic> json) {
  return AuthData(
    email: json['email'] as String,
    password: json['password'] as String,
  );
}

Map<String, dynamic> _$AuthDataToJson(AuthData instance) => <String, dynamic>{
      'email': instance.email,
      'password': instance.password,
    };
