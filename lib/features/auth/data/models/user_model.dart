import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_model.g.dart';

@HiveType(typeId: 100)
@JsonSerializable()
class UserModel {
  @HiveField(0)
  @JsonKey(name: 'id')
  final int id;

  @HiveField(1)
  @JsonKey(name: 'username')
  final String username;

  @HiveField(2)
  @JsonKey(name: 'email')
  final String email;

  @HiveField(3)
  @JsonKey(name: 'first_name')
  final String firstName;

  @HiveField(4)
  @JsonKey(name: 'last_name')
  final String lastName;

  @HiveField(5)
  @JsonKey(name: 'is_staff')
  final bool isStaff;

  @HiveField(6)
  @JsonKey(name: 'is_superuser')
  final bool isSuperuser;

  @HiveField(7)
  @JsonKey(name: 'groups')
  final List<String> groups;

  @HiveField(8)
  @JsonKey(name: 'user_permissions')
  final List<String> userPermissions;

  @HiveField(9)
  @JsonKey(name: 'last_login')
  final DateTime? lastLogin;

  @HiveField(10)
  @JsonKey(name: 'date_joined')
  final DateTime dateJoined;

  UserModel({
    required this.id,
    required this.username,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.isStaff,
    required this.isSuperuser,
    this.groups = const [],
    this.userPermissions = const [],
    this.lastLogin,
    required this.dateJoined,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserModelToJson(this);

  String get fullName => '$firstName $lastName';

  bool get isAdmin => isStaff || isSuperuser;

  bool hasPermission(String permission) {
    return userPermissions.contains(permission) || isSuperuser;
  }

  bool hasGroup(String group) {
    return groups.contains(group) || isSuperuser;
  }
}
