// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserModelAdapter extends TypeAdapter<UserModel> {
  @override
  final typeId = 100;

  @override
  UserModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserModel(
      id: fields[0] as int,
      username: fields[1] as String,
      email: fields[2] as String,
      firstName: fields[3] as String,
      lastName: fields[4] as String,
      isStaff: fields[5] as bool,
      isSuperuser: fields[6] as bool,
      groups: fields[7] as List<String>,
      userPermissions: fields[8] as List<String>,
      lastLogin: fields[9] as DateTime,
      dateJoined: fields[10] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, UserModel obj) {
    writer.writeByte(0);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserModel _$UserModelFromJson(Map json) => UserModel(
  id: (json['id'] as num).toInt(),
  username: json['username'] as String,
  email: json['email'] as String,
  firstName: json['first_name'] as String,
  lastName: json['last_name'] as String,
  isStaff: json['is_staff'] as bool,
  isSuperuser: json['is_superuser'] as bool,
  groups:
      (json['groups'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const [],
  userPermissions:
      (json['user_permissions'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const [],
  lastLogin: json['last_login'] == null
      ? null
      : DateTime.parse(json['last_login'] as String),
  dateJoined: DateTime.parse(json['date_joined'] as String),
);

Map<String, dynamic> _$UserModelToJson(UserModel instance) => <String, dynamic>{
  'id': instance.id,
  'username': instance.username,
  'email': instance.email,
  'first_name': instance.firstName,
  'last_name': instance.lastName,
  'is_staff': instance.isStaff,
  'is_superuser': instance.isSuperuser,
  'groups': instance.groups,
  'user_permissions': instance.userPermissions,
  'last_login': instance.lastLogin?.toIso8601String(),
  'date_joined': instance.dateJoined.toIso8601String(),
};
