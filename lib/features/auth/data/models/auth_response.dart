import 'package:json_annotation/json_annotation.dart';
import 'user_model.dart';

part 'auth_response.g.dart';

@JsonSerializable()
class AuthResponse {
  @JsonKey(name: 'access')
  final String accessToken;

  @JsonKey(name: 'refresh')
  final String refreshToken;

  @JsonKey(name: 'user')
  final UserModel user;

  AuthResponse({
    required this.accessToken,
    required this.refreshToken,
    required this.user,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) =>
      _$AuthResponseFromJson(json);

  Map<String, dynamic> toJson() => _$AuthResponseToJson(this);
}

@JsonSerializable()
class RefreshTokenResponse {
  @JsonKey(name: 'access')
  final String accessToken;

  RefreshTokenResponse({required this.accessToken});

  factory RefreshTokenResponse.fromJson(Map<String, dynamic> json) =>
      _$RefreshTokenResponseFromJson(json);

  Map<String, dynamic> toJson() => _$RefreshTokenResponseToJson(this);
}
