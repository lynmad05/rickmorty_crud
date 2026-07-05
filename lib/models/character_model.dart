class CharacterModel {
  final int? id;
  final int? apiId;
  final String name;
  final String status;
  final String species;
  final String gender;
  final String origin;
  final String imageUrl;

  const CharacterModel({
    this.id,
    this.apiId,
    required this.name,
    required this.status,
    required this.species,
    required this.gender,
    required this.origin,
    required this.imageUrl,
  });

  factory CharacterModel.fromApiJson(Map<String, dynamic> json) {
    final originMap = json['origin'] as Map<String, dynamic>?;
    return CharacterModel(
      apiId: json['id'] as int?,
      name: json['name'] as String? ?? '',
      status: json['status'] as String? ?? 'unknown',
      species: json['species'] as String? ?? '',
      gender: json['gender'] as String? ?? '',
      origin: originMap != null ? (originMap['name'] as String? ?? '') : '',
      imageUrl: json['image'] as String? ?? '',
    );
  }

  factory CharacterModel.fromMap(Map<String, dynamic> map) {
    return CharacterModel(
      id: map['id'] as int?,
      apiId: map['apiId'] as int?,
      name: map['name'] as String,
      status: map['status'] as String,
      species: map['species'] as String,
      gender: map['gender'] as String,
      origin: map['origin'] as String,
      imageUrl: map['imageUrl'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'apiId': apiId,
      'name': name,
      'status': status,
      'species': species,
      'gender': gender,
      'origin': origin,
      'imageUrl': imageUrl,
    };
  }

  CharacterModel copyWith({
    int? id,
    int? apiId,
    String? name,
    String? status,
    String? species,
    String? gender,
    String? origin,
    String? imageUrl,
  }) {
    return CharacterModel(
      id: id ?? this.id,
      apiId: apiId ?? this.apiId,
      name: name ?? this.name,
      status: status ?? this.status,
      species: species ?? this.species,
      gender: gender ?? this.gender,
      origin: origin ?? this.origin,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }
}
