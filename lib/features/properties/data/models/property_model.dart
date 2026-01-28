import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:property_tax_system_fd/features/ownership/data/models/ownership_model.dart';

part 'property_model.g.dart';

@HiveType(typeId: 1)
@JsonSerializable()
class PropertyModel {
  PropertyModel({
    required this.id,
    required this.propertyId,
    required this.address,
    required this.ward,
    required this.zone,
    required this.latitude,
    required this.longitude,
    required this.areaSqft,
    required this.propertyType,
    required this.constructionType,
    required this.yearBuilt,
    required this.isActive,
    this.currentOwner,
    this.currentValuation,
    this.annualTax,
    this.images = const [],
    required this.createdAt,
    required this.updatedAt,
  });

  factory PropertyModel.fromJson(Map<String, dynamic> json) =>
      _$PropertyModelFromJson(json);

  Map<String, dynamic> toJson() => _$PropertyModelToJson(this);

  @HiveField(0)
  @JsonKey(name: 'id')
  final int id;

  @HiveField(1)
  @JsonKey(name: 'property_id')
  final String propertyId;

  @HiveField(2)
  @JsonKey(name: 'address')
  final String address;

  @HiveField(3)
  @JsonKey(name: 'ward')
  final String ward;

  @HiveField(4)
  @JsonKey(name: 'zone')
  final String zone;

  @HiveField(5)
  @JsonKey(name: 'latitude')
  final double latitude;

  @HiveField(6)
  @JsonKey(name: 'longitude')
  final double longitude;

  @HiveField(7)
  @JsonKey(name: 'area_sqft')
  final double areaSqft;

  @HiveField(8)
  @JsonKey(name: 'property_type')
  final String propertyType; // RESIDENTIAL, COMMERCIAL, INDUSTRIAL

  @HiveField(9)
  @JsonKey(name: 'construction_type')
  final String constructionType; // RCC, FRAMED, LOAD_BEARING

  @HiveField(10)
  @JsonKey(name: 'year_built')
  final int yearBuilt;

  @HiveField(11)
  @JsonKey(name: 'is_active')
  final bool isActive;

  @HiveField(12)
  @JsonKey(name: 'current_owner')
  final OwnershipModel? currentOwner;

  @HiveField(13)
  @JsonKey(name: 'current_valuation')
  final double? currentValuation;

  @HiveField(14)
  @JsonKey(name: 'annual_tax')
  final double? annualTax;

  @HiveField(15)
  @JsonKey(name: 'images')
  final List<String> images;

  @HiveField(16)
  @JsonKey(name: 'created_at')
  final DateTime createdAt;

  @HiveField(17)
  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;
}
