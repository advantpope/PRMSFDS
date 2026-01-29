// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'valuation_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ValuationModelAdapter extends TypeAdapter<ValuationModel> {
  @override
  final typeId = 3;

  @override
  ValuationModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ValuationModel(
      id: fields[0] as int,
      propertyId: fields[1] as String,
      valuationDate: fields[2] as DateTime,
      marketValue: fields[3] as double,
      assessedValue: fields[4] as double,
      valuationMethod: fields[5] as String,
      valuationOfficer: fields[6] as String,
    );
  }

  @override
  void write(BinaryWriter writer, ValuationModel obj) {
    writer.writeByte(0);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ValuationModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ValuationModel _$ValuationModelFromJson(Map json) => ValuationModel(
  id: (json['id'] as num).toInt(),
  propertyId: json['property_id'] as String,
  valuationDate: DateTime.parse(json['valuation_date'] as String),
  marketValue: (json['market_value'] as num).toDouble(),
  assessedValue: (json['assessed_value'] as num).toDouble(),
  valuationMethod: json['valuation_method'] as String,
  valuationOfficer: json['valuation_officer'] as String,
  notes: json['notes'] as String?,
);

Map<String, dynamic> _$ValuationModelToJson(ValuationModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'property_id': instance.propertyId,
      'valuation_date': instance.valuationDate.toIso8601String(),
      'market_value': instance.marketValue,
      'assessed_value': instance.assessedValue,
      'valuation_method': instance.valuationMethod,
      'valuation_officer': instance.valuationOfficer,
      'notes': instance.notes,
    };
