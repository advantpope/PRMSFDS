// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tax_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TaxModelAdapter extends TypeAdapter<TaxModel> {
  @override
  final typeId = 4;

  @override
  TaxModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TaxModel(
      id: fields[0] as int,
      propertyId: fields[1] as String,
      year: fields[2] as int,
      taxAmount: fields[3] as double,
      paidAmount: fields[4] as double,
      balance: fields[5] as double,
      dueDate: fields[6] as DateTime,
      status: fields[6] as String,
    );
  }

  @override
  void write(BinaryWriter writer, TaxModel obj) {
    writer.writeByte(0);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TaxModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TaxModel _$TaxModelFromJson(Map json) => TaxModel(
  id: (json['id'] as num).toInt(),
  propertyId: json['property_id'] as String,
  year: (json['year'] as num).toInt(),
  taxAmount: (json['tax_amount'] as num).toDouble(),
  paidAmount: (json['paid_amount'] as num).toDouble(),
  balance: (json['balance'] as num).toDouble(),
  dueDate: DateTime.parse(json['due_date'] as String),
  paymentDate: json['payment_date'] == null
      ? null
      : DateTime.parse(json['payment_date'] as String),
  status: json['status'] as String,
  paymentMethod: json['payment_method'] as String?,
  receiptNumber: json['receipt_number'] as String?,
);

Map<String, dynamic> _$TaxModelToJson(TaxModel instance) => <String, dynamic>{
  'id': instance.id,
  'property_id': instance.propertyId,
  'year': instance.year,
  'tax_amount': instance.taxAmount,
  'paid_amount': instance.paidAmount,
  'balance': instance.balance,
  'due_date': instance.dueDate.toIso8601String(),
  'payment_date': instance.paymentDate?.toIso8601String(),
  'status': instance.status,
  'payment_method': instance.paymentMethod,
  'receipt_number': instance.receiptNumber,
};
