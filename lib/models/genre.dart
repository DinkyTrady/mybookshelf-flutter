class Genre {
  final String _id;
  final String _name;

  String get id => _id;
  String get name => _name;

  Genre({required String id, required String name}) : _id = id, _name = name;

  Genre copyWith({String? id, String? name}) {
    return Genre(id: id ?? this.id, name: name ?? this.name);
  }

  factory Genre.fromMap(Map<String, dynamic> map) {
    return Genre(id: map['id'], name: map['name']);
  }

  Map<String, dynamic> toMap() {
    return {'id': _id, 'name': _name};
  }
}
