// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AuthResponse _$AuthResponseFromJson(Map json) => AuthResponse(
  accessToken: json['access'] as String,
  refreshToken: json['refresh'] as String,
  user: UserModel.fromJson(Map<String, dynamic>.from(json['user'] as Map)),
);

Map<String, dynamic> _$AuthResponseToJson(AuthResponse instance) =>
    <String, dynamic>{
      'access': instance.accessToken,
      'refresh': instance.refreshToken,
      'user': instance.user.toJson(),
    };

RefreshTokenResponse _$RefreshTokenResponseFromJson(Map json) =>
    RefreshTokenResponse(accessToken: json['access'] as String);

Map<String, dynamic> _$RefreshTokenResponseToJson(
  RefreshTokenResponse instance,
) => <String, dynamic>{'access': instance.accessToken};
