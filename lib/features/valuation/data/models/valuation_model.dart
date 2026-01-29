import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

part 'valuation_model.g.dart';

@HiveType(typeId: 3)
@JsonSerializable()
class ValuationModel {
  @HiveField(0)
  @JsonKey(name: 'id')
  final int id;

  @HiveField(1)
  @JsonKey(name: 'property_id')
  final String propertyId;

  @HiveField(2)
  @JsonKey(name: 'valuation_date')
  final DateTime valuationDate;

  @HiveField(3)
  @JsonKey(name: 'market_value')
  final double marketValue;

  @HiveField(4)
  @JsonKey(name: 'assessed_value')
  final double assessedValue;

  @HiveField(5)
  @JsonKey(name: 'valuation_method')
  final String valuationMethod;

  @HiveField(6)
  @JsonKey(name: 'valuation_officer')
  final String valuationOfficer;

  @HiveField(7)
  @JsonKey(name: 'notes')
  final String? notes;

  ValuationModel({
    required this.id,
    required this.propertyId,
    required this.valuationDate,
    required this.marketValue,
    required this.assessedValue,
    required this.valuationMethod,
    required this.valuationOfficer,
    this.notes,
  });

  factory ValuationModel.fromJson(Map<String, dynamic> json) =>
      _$ValuationModelFromJson(json);

  Map<String, dynamic> toJson() => _$ValuationModelToJson(this);
}
