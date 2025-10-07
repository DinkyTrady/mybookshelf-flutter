import 'package:web_flut/models/base.dart';

abstract class BaseUser extends Base {
  final String _firstName;
  final String? _lastName;
  final String _biography;

  BaseUser({
    required super.id,
    required String firstName,
    required String? lastName,
    required String biography,
    super.updatedAt,
  }) : _firstName = firstName,
       _lastName = lastName,
       _biography = biography;

  String get firstName => _firstName;
  String? get lastName => _lastName;
  String get biography => _biography;
  String get fullName => '$_firstName${_lastName != null ? ' $_lastName' : ''}';

  String get fullInfo;

  @override
  Map<String, dynamic> toMap() {
    final baseMap = super.toMap();
    baseMap.addAll({
      'firstName': _firstName,
      'lastName': _lastName,
      'biography': _biography,
    });
    return baseMap;
  }

  factory BaseUser.fromMap(Map<String, dynamic> map) {
    throw UnimplementedError('fromMap() must be implemented in subclasses');
  }
}
