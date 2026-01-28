import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

part 'ownership_model.g.dart';

@HiveType(typeId: 2) // MUST be unique
@JsonSerializable()
class OwnershipModel {
  OwnershipModel({
    required this.id,
    required this.ownerName,
    required this.ownerPhone,
  });

  factory OwnershipModel.fromJson(Map<String, dynamic> json) =>
      _$OwnershipModelFromJson(json);

  Map<String, dynamic> toJson() => _$OwnershipModelToJson(this);

  @HiveField(0)
  final int id;

  @HiveField(1)
  final String ownerName;

  @HiveField(2)
  final String ownerPhone;
}
