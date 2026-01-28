import 'package:json_annotation/json_annotation.dart';

part 'api_response.g.dart';

@JsonSerializable(genericArgumentFactories: true)
class ApiResponse<T> {
  ApiResponse({this.count, this.next, this.previous, required this.results});

  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Object? json) fromJsonT,
  ) => _$ApiResponseFromJson(json, fromJsonT);
  @JsonKey(name: 'count')
  final int? count;

  @JsonKey(name: 'next')
  final String? next;

  @JsonKey(name: 'previous')
  final String? previous;

  @JsonKey(name: 'results')
  final List<T> results;

  Map<String, dynamic> toJson(Object? Function(T value) toJsonT) =>
      _$ApiResponseToJson(this, toJsonT);
}

// For single object responses (not paginated)
@JsonSerializable(genericArgumentFactories: true)
class SingleApiResponse<T> {
  SingleApiResponse({required this.data});

  factory SingleApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Object? json) fromJsonT,
  ) => _$SingleApiResponseFromJson(json, fromJsonT);
  @JsonKey(name: 'data')
  final T data;

  Map<String, dynamic> toJson(Object? Function(T value) toJsonT) =>
      _$SingleApiResponseToJson(this, toJsonT);
}
