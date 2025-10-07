import 'package:web_flut/models/users/base_user.dart';

enum Roles { normal, admin, superAdmin }

class UserAccount extends BaseUser {
  final String _email;
  final String _password;
  final Roles _role = Roles.normal;

  UserAccount({
    required super.id,
    required super.firstName,
    super.lastName,
    required super.biography,
    required String email,
    required String password,
    Roles role = Roles.normal,
    super.updatedAt,
  }) : _email = email,
       _password = password;

  UserAccount copyWith({
    String? id,
    String? firstName,
    String? lastName,
    String? biography,
    String? email,
    String? password,
    Roles? role,
    DateTime? updatedAt,
  }) {
    return UserAccount(
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      biography: biography ?? this.biography,
      email: email ?? _email,
      password: password ?? _password,
      role: role ?? _role,
      updatedAt: updatedAt ?? DateTime.now(),
    );
  }

  String get email => _email;
  String get password => _password;
  String get role => _role.toString();

  @override
  String get fullInfo {
    return '$fullName ($role) - \n $biography';
  }

  factory UserAccount.fromMap(Map<String, dynamic> map) {
    String? roleStr = map['role'];
    if (roleStr != null && roleStr.startsWith('Roles.')) {
      roleStr = roleStr.substring(6);
    }
    final roleEnum = roleStr != null
        ? Roles.values.firstWhere(
            (r) => r.toString().split('.').last == roleStr,
            orElse: () => Roles.normal,
          )
        : Roles.normal;

    return UserAccount(
      id: map['id'],
      firstName: map['firstName'],
      lastName: map['lastName'],
      biography: map['biography'] ?? '',
      email: map['email'],
      password: map['password'],
      role: roleEnum,
      updatedAt: map['updatedAt'] != null
          ? DateTime.parse(map['updatedAt'])
          : null,
    );
  }

  @override
  Map<String, dynamic> toMap() {
    final baseMap = super.toMap();
    baseMap.addAll({'email': email, 'password': password, 'role': role});
    return baseMap;
  }
}
