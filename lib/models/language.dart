class Language {
  final String _id;
  final String _name;
  final String _code; // e.g., 'en', 'es', 'fr'

  String get id => _id;
  String get name => _name;
  String get code => _code;

  Language({required String id, required String name, required String code})
    : _id = id,
      _name = name,
      _code = code;

  Language copyWith({String? id, String? name, String? code}) {
    return Language(
      id: id ?? this.id,
      name: name ?? this.name,
      code: code ?? this.code,
    );
  }

  factory Language.fromMap(Map<String, dynamic> map) {
    return Language(id: map['id'], name: map['name'], code: map['code']);
  }

  Map<String, dynamic> toMap() {
    return {'id': _id, 'name': _name, 'code': _code};
  }
}
