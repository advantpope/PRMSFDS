// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LoginRequest _$LoginRequestFromJson(Map json) => LoginRequest(
  username: json['username'] as String,
  password: json['password'] as String,
);

Map<String, dynamic> _$LoginRequestToJson(LoginRequest instance) =>
    <String, dynamic>{
      'username': instance.username,
      'password': instance.password,
    };

RegisterRequest _$RegisterRequestFromJson(Map json) => RegisterRequest(
  username: json['username'] as String,
  email: json['email'] as String,
  password1: json['password1'] as String,
  password2: json['password2'] as String,
  firstName: json['first_name'] as String,
  lastName: json['last_name'] as String,
);

Map<String, dynamic> _$RegisterRequestToJson(RegisterRequest instance) =>
    <String, dynamic>{
      'username': instance.username,
      'email': instance.email,
      'password1': instance.password1,
      'password2': instance.password2,
      'first_name': instance.firstName,
      'last_name': instance.lastName,
    };
