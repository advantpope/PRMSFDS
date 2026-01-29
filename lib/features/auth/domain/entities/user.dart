import 'package:equatable/equatable.dart';

class User extends Equatable {
  const User({
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
  final int id;
  final String username;
  final String email;
  final String firstName;
  final String lastName;
  final bool isStaff;
  final bool isSuperuser;
  final List<String> groups;
  final List<String> userPermissions;
  final DateTime? lastLogin;
  final DateTime dateJoined;

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as int,
      username: json['username'] as String,
      email: json['email'] as String,
      firstName: json['first_name'] as String,
      lastName: json['last_name'] as String,
      isStaff: json['is_staff'] as bool,
      isSuperuser: json['is_superuser'] as bool,
      groups: List<String>.from(json['groups'] ?? []),
      userPermissions: List<String>.from(json['user_permissions'] ?? []),
      lastLogin: json['last_login'] != null
          ? DateTime.parse(json['last_login'] as String)
          : null,
      dateJoined: DateTime.parse(json['date_joined'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'first_name': firstName,
      'last_name': lastName,
      'is_staff': isStaff,
      'is_superuser': isSuperuser,
      'groups': groups,
      'user_permissions': userPermissions,
      'last_login': lastLogin?.toIso8601String(),
      'date_joined': dateJoined.toIso8601String(),
    };
  }

  String get fullName => '$firstName $lastName';

  bool get isAdmin => isStaff || isSuperuser;

  bool hasPermission(String permission) {
    return userPermissions.contains(permission) || isSuperuser;
  }

  bool hasGroup(String group) {
    return groups.contains(group) || isSuperuser;
  }

  User copyWith({
    int? id,
    String? username,
    String? email,
    String? firstName,
    String? lastName,
    bool? isStaff,
    bool? isSuperuser,
    List<String>? groups,
    List<String>? userPermissions,
    DateTime? lastLogin,
    DateTime? dateJoined,
  }) {
    return User(
      id: id ?? this.id,
      username: username ?? this.username,
      email: email ?? this.email,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      isStaff: isStaff ?? this.isStaff,
      isSuperuser: isSuperuser ?? this.isSuperuser,
      groups: groups ?? this.groups,
      userPermissions: userPermissions ?? this.userPermissions,
      lastLogin: lastLogin ?? this.lastLogin,
      dateJoined: dateJoined ?? this.dateJoined,
    );
  }

  @override
  List<Object?> get props => [
    id,
    username,
    email,
    firstName,
    lastName,
    isStaff,
    isSuperuser,
    groups,
    userPermissions,
    lastLogin,
    dateJoined,
  ];

  @override
  bool get stringify => true;

  static final User empty = User(
    id: 0,
    username: '',
    email: '',
    firstName: '',
    lastName: '',
    isStaff: false,
    isSuperuser: false,
    groups: const [],
    userPermissions: const [],
    lastLogin: null,
    dateJoined: DateTime(1970),
  );

  bool get isEmpty => this == empty;
  bool get isNotEmpty => this != empty;
}
