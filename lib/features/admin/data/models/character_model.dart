import 'package:timeexplorer/features/admin/domain/entities/character_entity.dart';

class CharacterModel extends CharacterEntity {
  const CharacterModel({
    required super.id,
    required super.name,
    required super.category,
    required super.era,
    required super.description,
    super.imageUrl,
    super.title,
    super.birthYear,
    super.deathYear,
    super.nationality,
    super.achievements,
    super.legacy,
  });

  factory CharacterModel.fromMap(Map<String, dynamic> map, String id) {
    return CharacterModel(
      id:           id,
      name:         map['name'] ?? '',
      category:     map['category'] ?? 'Other',
      era:          map['era'] ?? '',
      description:  map['description'] ?? '',
      imageUrl:     map['imageUrl'],
      title:        map['title'],
      birthYear:    map['birthYear'],
      deathYear:    map['deathYear'],
      nationality:  map['nationality'],
      achievements: (map['achievements'] as List?)?.map((e) => e.toString()).toList(),
      legacy:       map['legacy'],
    );
  }

  Map<String, dynamic> toMap() => {
    'name':         name,
    'category':     category,
    'era':          era,
    'description':  description,
    'imageUrl':     imageUrl,
    'title':        title,
    'birthYear':    birthYear,
    'deathYear':    deathYear,
    'nationality':  nationality,
    'achievements': achievements,
    'legacy':       legacy,
  };
}
