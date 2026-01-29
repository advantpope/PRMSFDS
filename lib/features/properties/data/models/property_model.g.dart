// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'property_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PropertyModelAdapter extends TypeAdapter<PropertyModel> {
  @override
  final typeId = 1;

  @override
  PropertyModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PropertyModel(
      id: fields[0] as int,
      propertyId: fields[1] as String,
      address: fields[2] as String,
      ward: fields[3] as String,
      zone: fields[4] as String,
      latitude: fields[5] as double,
      longitude: fields[6] as double,
      areaSqft: fields[7] as double,
      propertyType: fields[8] as String,
      constructionType: fields[9] as String,
      yearBuilt: fields[10] as int,
      isActive: fields[11] as bool,
      currentOwner: fields[12] as OwnershipModel,
      currentValuation: fields[13] as double,
      annualTax: fields[14] as double,
      images: fields[15] as List<String>,
      createdAt: fields[16] as DateTime,
      updatedAt: fields[17] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, PropertyModel obj) {
    writer.writeByte(0);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PropertyModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PropertyModel _$PropertyModelFromJson(Map json) => PropertyModel(
  id: (json['id'] as num).toInt(),
  propertyId: json['property_id'] as String,
  address: json['address'] as String,
  ward: json['ward'] as String,
  zone: json['zone'] as String,
  latitude: (json['latitude'] as num).toDouble(),
  longitude: (json['longitude'] as num).toDouble(),
  areaSqft: (json['area_sqft'] as num).toDouble(),
  propertyType: json['property_type'] as String,
  constructionType: json['construction_type'] as String,
  yearBuilt: (json['year_built'] as num).toInt(),
  isActive: json['is_active'] as bool,
  currentOwner: json['current_owner'] == null
      ? null
      : OwnershipModel.fromJson(
          Map<String, dynamic>.from(json['current_owner'] as Map),
        ),
  currentValuation: (json['current_valuation'] as num?)?.toDouble(),
  annualTax: (json['annual_tax'] as num?)?.toDouble(),
  images:
      (json['images'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const [],
  createdAt: DateTime.parse(json['created_at'] as String),
  updatedAt: DateTime.parse(json['updated_at'] as String),
);

Map<String, dynamic> _$PropertyModelToJson(PropertyModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'property_id': instance.propertyId,
      'address': instance.address,
      'ward': instance.ward,
      'zone': instance.zone,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'area_sqft': instance.areaSqft,
      'property_type': instance.propertyType,
      'construction_type': instance.constructionType,
      'year_built': instance.yearBuilt,
      'is_active': instance.isActive,
      'current_owner': instance.currentOwner?.toJson(),
      'current_valuation': instance.currentValuation,
      'annual_tax': instance.annualTax,
      'images': instance.images,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
    };
