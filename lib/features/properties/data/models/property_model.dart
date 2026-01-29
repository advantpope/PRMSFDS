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
  PropertyModel copyWith({
    int? id,
    String? propertyId,
    String? address,
    String? ward,
    String? zone,
    double? latitude,
    double? longitude,
    double? areaSqft,
    String? propertyType,
    String? constructionType,
    int? yearBuilt,
    bool? isActive,
    OwnershipModel? currentOwner,
    double? currentValuation,
    double? annualTax,
    List<String>? images,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return PropertyModel(
      id: id ?? this.id,
      propertyId: propertyId ?? this.propertyId,
      address: address ?? this.address,
      ward: ward ?? this.ward,
      zone: zone ?? this.zone,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      areaSqft: areaSqft ?? this.areaSqft,
      propertyType: propertyType ?? this.propertyType,
      constructionType: constructionType ?? this.constructionType,
      yearBuilt: yearBuilt ?? this.yearBuilt,
      isActive: isActive ?? this.isActive,
      currentOwner: currentOwner ?? this.currentOwner,
      currentValuation: currentValuation ?? this.currentValuation,
      annualTax: annualTax ?? this.annualTax,
      images: images ?? this.images,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  factory PropertyModel.fromJson(Map<String, dynamic> json) =>
      _$PropertyModelFromJson(json);

  Map<String, dynamic> toJson() => _$PropertyModelToJson(this);

  @HiveField(0)
  @JsonKey(name: 'id')
  late final int id;

  @HiveField(1)
  @JsonKey(name: 'property_id')
  late final String propertyId;

  @HiveField(2)
  @JsonKey(name: 'address')
  late final String address;

  @HiveField(3)
  @JsonKey(name: 'ward')
  late final String ward;

  @HiveField(4)
  @JsonKey(name: 'zone')
  late final String zone;

  @HiveField(5)
  @JsonKey(name: 'latitude')
  late final double latitude;

  @HiveField(6)
  @JsonKey(name: 'longitude')
  late final double longitude;

  @HiveField(7)
  @JsonKey(name: 'area_sqft')
  late final double areaSqft;

  @HiveField(8)
  @JsonKey(name: 'property_type')
  late final String propertyType; // RESIDENTIAL, COMMERCIAL, INDUSTRIAL

  @HiveField(9)
  @JsonKey(name: 'construction_type')
  late final String constructionType; // RCC, FRAMED, LOAD_BEARING

  @HiveField(10)
  @JsonKey(name: 'year_built')
  late final int yearBuilt;

  @HiveField(11)
  @JsonKey(name: 'is_active')
  late final bool isActive;

  @HiveField(12)
  @JsonKey(name: 'current_owner')
  late final OwnershipModel? currentOwner;

  @HiveField(13)
  @JsonKey(name: 'current_valuation')
  late final double? currentValuation;

  @HiveField(14)
  @JsonKey(name: 'annual_tax')
  late final double? annualTax;

  @HiveField(15)
  @JsonKey(name: 'images')
  late final List<String> images;

  @HiveField(16)
  @JsonKey(name: 'created_at')
  late final DateTime createdAt;

  @HiveField(17)
  @JsonKey(name: 'updated_at')
  late final DateTime updatedAt;
}
