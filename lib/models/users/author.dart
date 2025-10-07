import 'package:web_flut/models/users/base_user.dart';

class Author extends BaseUser {
  final DateTime _dateOfBirth;
  final DateTime? _dateOfDeath;

  Author({
    required super.id,
    required super.firstName,
    super.lastName,
    required super.biography,
    required DateTime dateOfBirth,
    DateTime? dateOfDeath,
    super.updatedAt,
  }) : _dateOfBirth = dateOfBirth,
       _dateOfDeath = dateOfDeath;

  Author copyWith({
    String? id,
    String? firstName,
    String? lastName,
    String? biography,
    DateTime? dateOfBirth,
    DateTime? dateOfDeath,
    DateTime? updatedAt,
  }) {
    return Author(
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      biography: biography ?? this.biography,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      dateOfDeath: dateOfDeath ?? this.dateOfDeath,
      updatedAt: updatedAt ?? DateTime.now(),
    );
  }

  DateTime get dateOfBirth => _dateOfBirth;
  DateTime? get dateOfDeath => _dateOfDeath;

  @override
  String get fullInfo {
    return '$fullName - ${_dateOfBirth.toIso8601String()}'
        '${dateOfDeath != null ? '(${dateOfDeath!.toIso8601String()})' : ''}\n$biography';
  }

  factory Author.fromMap(Map<String, dynamic> map) {
    return Author(
      id: map['id'],
      firstName: map['firstName'],
      lastName: map['lastName'],
      biography: map['biography'],
      dateOfBirth: DateTime.parse(map['dateOfBirth']),
      dateOfDeath: map['dateOfDeath'] != null
          ? DateTime.parse(map['dateOfDeath'])
          : null,
      updatedAt: map['updatedAt'] != null
          ? DateTime.parse(map['updatedAt'])
          : null,
    );
  }

  @override
  Map<String, dynamic> toMap() {
    final baseMap = super.toMap();
    baseMap.addAll({
      'dateOfBirth': _dateOfBirth.toIso8601String(),
      'dateOfDeath': _dateOfDeath?.toIso8601String(),
    });
    return baseMap;
  }
}
