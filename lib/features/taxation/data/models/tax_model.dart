import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

part 'tax_model.g.dart';

@HiveType(typeId: 4)
@JsonSerializable()
class TaxModel {
  factory TaxModel.fromJson(Map<String, dynamic> json) =>
      _$TaxModelFromJson(json);
  @HiveField(0)
  @JsonKey(name: 'id')
  final int id;

  @HiveField(1)
  @JsonKey(name: 'property_id')
  final String propertyId;

  @HiveField(2)
  @JsonKey(name: 'year')
  final int year;

  @HiveField(3)
  @JsonKey(name: 'tax_amount')
  final double taxAmount;

  @HiveField(4)
  @JsonKey(name: 'paid_amount')
  final double paidAmount;

  @HiveField(5)
  @JsonKey(name: 'balance')
  final double balance;

  @HiveField(6)
  @JsonKey(name: 'due_date')
  final DateTime dueDate;

  @HiveField(7)
  @JsonKey(name: 'payment_date')
  final DateTime? paymentDate;

  @HiveField(8)
  @JsonKey(name: 'status')
  final String status; // PENDING, PARTIAL, PAID, OVERDUE

  @HiveField(9)
  @JsonKey(name: 'payment_method')
  final String? paymentMethod;

  @HiveField(10)
  @JsonKey(name: 'receipt_number')
  final String? receiptNumber;

  TaxModel({
    required this.id,
    required this.propertyId,
    required this.year,
    required this.taxAmount,
    required this.paidAmount,
    required this.balance,
    required this.dueDate,
    this.paymentDate,
    required this.status,
    this.paymentMethod,
    this.receiptNumber,
  });

  Map<String, dynamic> toJson() => _$TaxModelToJson(this);

  bool get isPaid => status == 'PAID';
  bool get isOverdue => status == 'OVERDUE';
  bool get isPartial => status == 'PARTIAL';
}
