// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ApiResponse<T> _$ApiResponseFromJson<T>(
  Map json,
  T Function(Object? json) fromJsonT,
) => ApiResponse<T>(
  count: (json['count'] as num?)?.toInt(),
  next: json['next'] as String?,
  previous: json['previous'] as String?,
  results: (json['results'] as List<dynamic>).map(fromJsonT).toList(),
);

Map<String, dynamic> _$ApiResponseToJson<T>(
  ApiResponse<T> instance,
  Object? Function(T value) toJsonT,
) => <String, dynamic>{
  'count': instance.count,
  'next': instance.next,
  'previous': instance.previous,
  'results': instance.results.map(toJsonT).toList(),
};

SingleApiResponse<T> _$SingleApiResponseFromJson<T>(
  Map json,
  T Function(Object? json) fromJsonT,
) => SingleApiResponse<T>(data: fromJsonT(json['data']));

Map<String, dynamic> _$SingleApiResponseToJson<T>(
  SingleApiResponse<T> instance,
  Object? Function(T value) toJsonT,
) => <String, dynamic>{'data': toJsonT(instance.data)};
