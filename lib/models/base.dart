abstract class Base {
  final String _id;
  final DateTime _createdAt = DateTime.now();
  final DateTime? _updatedAt;

  Base({required String id, DateTime? updatedAt})
    : _id = id,
      _updatedAt = updatedAt;

  String get id => _id;
  DateTime get createdAt => _createdAt;
  DateTime? get updatedAt => _updatedAt;

  Map<String, dynamic> toMap() {
    return {
      'id': _id,
      'createdAt': _createdAt.toIso8601String(),
      'updatedAt': _updatedAt?.toIso8601String(),
    };
  }
}
