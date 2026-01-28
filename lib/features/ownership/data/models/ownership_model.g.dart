// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ownership_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class OwnershipModelAdapter extends TypeAdapter<OwnershipModel> {
  @override
  final typeId = 2;

  @override
  OwnershipModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return OwnershipModel(
      id: fields[0] as int,
      ownerName: fields[1] as String,
      ownerPhone: fields[2] as String,
    );
  }

  @override
  void write(BinaryWriter writer, OwnershipModel obj) {
    writer.writeByte(0);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OwnershipModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OwnershipModel _$OwnershipModelFromJson(Map json) => OwnershipModel(
  id: (json['id'] as num).toInt(),
  ownerName: json['ownerName'] as String,
  ownerPhone: json['ownerPhone'] as String,
);

Map<String, dynamic> _$OwnershipModelToJson(OwnershipModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'ownerName': instance.ownerName,
      'ownerPhone': instance.ownerPhone,
    };
